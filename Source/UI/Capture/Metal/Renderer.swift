//
//  Renderer.swift
//  Slate
//
//  Created by John Coates on 9/29/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Metal
import MetalKit
import CoreVideo
import AVFoundation
import MetalPerformanceShaders

@objc class Renderer: NSObject, MTKViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    weak var view: MTKView!
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    var renderPipelineState: MTLRenderPipelineState!
    var vertices = [Vertex]()
    var textureCoordinates = [float2]()
    var vertexBuffer: MTLBuffer
    var textureCoordinatesBuffer: MTLBuffer
    
    var defaultVertexFunction: MTLFunction
    var defaultFragmentFunction: MTLFunction
    let cameraController = CameraController()
    var metalPerformanceShaders = false
    
    init?(metalView: MTKView) {
        view = metalView
        view.clearColor = MTLClearColorMake(1, 1, 1, 1)
        view.colorPixelFormat = .bgra8Unorm
        
        device = Renderer.getDevice()
        
        // Create the command queue to submit work to the GPU
        commandQueue = device.makeCommandQueue()
        
        guard let shaders = Renderer.getDefaultLibrary(withDevice: device) else {
            print("Unable to build shaders")
            return nil
        }
        defaultVertexFunction = shaders.vertexFunction
        defaultFragmentFunction = shaders.fragmentFunction
        
        vertexBuffer = Renderer.generateQuad(forDevice: device, inArray: &vertices)
        textureCoordinatesBuffer = Renderer.generate(textureCoordinates: &textureCoordinates, forDevice: device)
        super.init()
        
        do {
            renderPipelineState = try buildRenderPipeline()
        } catch {
            print("Unable to compile render pipeline state")
            return nil
        }
        
        setUpVideoQuadTexture()
        cameraController.setCaptureHandler(instance: self,
                                           method: Method.captureHandler)
        cameraController.startCapturingVideo()
        setUpMetal()
    }
    
    // MARK: - Startup
    
    func setUpMetal() {
        // MetalPerformanceShaders are a compute framework
        // Drawable texture is written to, not rendered to
        view.framebufferOnly = false
        // Draw loop is managed manually whenever new frame is received
        view.isPaused = true
        view.delegate = self
        view.device = device
        
        let metalPerformanceShadersSupported = MPSSupportsMTLDevice(device)
        if metalPerformanceShadersSupported {
            metalPerformanceShaders = true
        }
        print("metal performance shaders supported? \(metalPerformanceShadersSupported)")
    }
    
    class func getDevice() -> MTLDevice {
        #if os(iOS)
            if let defaultDevice = MTLCreateSystemDefaultDevice() {
                return defaultDevice
            } else {
                fatalError("Metal is not supported")
            }
        #endif
        
        #if os(macOS)
            let devices = MTLCopyAllDevices()
            switch devices.count {
            case 0:
                fatalError("Metal is not supported")
            case 2:
                // temporary workaround for bug that gives bad
                // performance on discrete GPU
                return devices[1]
            default:
                return devices[0]
            }
        #endif
    }
    
    // developer.apple.com/library/content/documentation/Miscellaneous/
    // Conceptual/MetalProgrammingGuide/Render-Ctx/Render-Ctx.html
    
    // Metal defines its Normalized Device Coordinate (NDC) system as a 2x2x1 cube with its center a
    // (0, 0, 0.5). The left and bottom for x and y, respectively, of the NDC system are specified as -1.
    // The right and top for x and y, respectively, of the NDC system are specified as +1.
    class func generateQuad(forDevice device: MTLDevice, inArray vertices: inout [Vertex]) -> MTLBuffer {
        vertices += Vertices.quad()
        
        var options: MTLResourceOptions = []
        #if os(macOS)
            options = [.storageModeManaged]
        #endif
        
        return device.makeBuffer(bytes: vertices,
                                 length: MemoryLayout<Vertex>.stride * vertices.count,
                                 options: options)
    }
    
    class func generate(textureCoordinates coordinates: inout[float2], forDevice device: MTLDevice) -> MTLBuffer {
        
        var options: MTLResourceOptions = []
        #if os(macOS)
            coordinates += TextureCoordinates.macHorizontalFlipped()
            options = [.storageModeManaged]
        #endif
        
        #if os(iOS)
            coordinates += TextureCoordinates.devicePortrait()
        #endif
        
        return device.makeBuffer(bytes: coordinates,
                                 length: MemoryLayout<float2>.stride * coordinates.count,
                                 options: options)
    }
    
    class func getDefaultLibrary(withDevice device: MTLDevice)
        -> (library: MTLLibrary,
        vertexFunction: MTLFunction,
        fragmentFunction: MTLFunction)? {
        
        guard let library = device.newDefaultLibrary() else {
            fatalError("Couldn't find shader libary")
        }
        
        // Retrieve the functions that will comprise our pipeline
        guard let vertexFunction = library.makeFunction(name: "vertexPassthrough"),
            let fragmentFunction = library.makeFunction(name: "fragmentPassthrough") else {
                print("Couldn't get shader functions")
                return nil
            }
        
        return (
            library: library,
            vertexFunction: vertexFunction,
            fragmentFunction: fragmentFunction
            )
        
    }
    
    func buildRenderPipeline(withFragmentFunction
        passedFragmentFunction: MTLFunction? = nil) throws
        -> MTLRenderPipelineState {
        
        let fragmentFunction: MTLFunction
        if let passedFragmentFunction = passedFragmentFunction {
            fragmentFunction = passedFragmentFunction
        } else {
            fragmentFunction = defaultFragmentFunction
        }
        // A render pipeline descriptor describes the configuration of our programmable pipeline
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.label = "Render Pipeline"
        pipelineDescriptor.sampleCount = view.sampleCount
        pipelineDescriptor.vertexFunction = defaultVertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = view.depthStencilPixelFormat
        
        // compile intermediate shaders into hardward-optimized code
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    // MARK: - Render
    
    func render(_ view: MTKView) {
        // Our command buffer is a container for the work we want to perform with the GPU.
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        guard let texture = self.texture else {
            print("no texture!")
            return
        }
        
        // Ask the view for a configured render pass descriptor. It will have a loadAction of
        // MTLLoadActionClear and have the clear color of the drawable set to our desired clear color.
        guard let currentDrawable = view.currentDrawable else {
            fatalError("no drawable!")
        }
//        print("drawing")
        
        if metalPerformanceShaders {
            blurTexture(withCommandBuffer: commandBuffer, textureIn: texture, textureOut: currentDrawable.texture)
        } else {
            renderFullScreen(commandBuffer: commandBuffer, drawable: currentDrawable)
        }
//
//        passthrough(withCommandBuffer: commandBuffer,
//                    sourceTexture: texture,
//                    destinationTexture: currentDrawable.texture)
        
        // Tell the system to present the cleared drawable to the screen.
        commandBuffer.present(currentDrawable)
        
        // Now that we're done issuing commands, we commit our buffer so the GPU can get to work.
        commandBuffer.commit()
    }
    
    func passthrough(withCommandBuffer commandBuffer: MTLCommandBuffer,
                     sourceTexture: MTLTexture,
                     destinationTexture: MTLTexture) {
        let blitCommandEncoder = commandBuffer.makeBlitCommandEncoder()
//        print("source texture width, height: \(sourceTexture.width), \(sourceTexture.height)")
//        print("destination texture width, height: \(destinationTexture.width), \(destinationTexture.height)")
        blitCommandEncoder.copy(from: sourceTexture,
                                sourceSlice: 0,
                                sourceLevel: 0,
                                sourceOrigin: MTLOriginMake(0, 0, 0),
                                sourceSize: MTLSizeMake(sourceTexture.width, sourceTexture.height, 1),
                                to: destinationTexture,
                                destinationSlice: 0,
                                destinationLevel: 0,
                                destinationOrigin: MTLOriginMake(0, 0, 0))
        blitCommandEncoder.endEncoding()
    }
    
    func renderFullScreen(commandBuffer: MTLCommandBuffer, drawable: CAMetalDrawable) {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1)
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .dontCare
        #if METAL_DEVICE
            renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        #endif
        
        // Create a render encoder to clear the screen and draw our objects
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        renderTextureQuad(renderEncoder: renderEncoder, view: view, identifier: "video texture")
        
        // We are finished with this render command encoder, so end it.
        renderEncoder.endEncoding()
    }
    
    // MARK: - Texture
    
    func setUpVideoQuadTexture() {
        #if METAL_DEVICE
        guard CVMetalTextureCacheCreate(kCFAllocatorDefault,
                                        nil, // cache attributes
            device,
            nil, // texture attributes
            &textureCache) == kCVReturnSuccess else {
                fatalError("Couldn't create a texture cache")
        }
        #endif
        
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.label = "video texture sampler"
        sampler = device.makeSamplerState(descriptor: samplerDescriptor)
        guard sampler != nil else {
            fatalError("Couldn't create a texture sampler")
        }
    }
    
    // MARK: - Video
    
    var texture: MTLTexture?
    var sampler: MTLSamplerState!
    
    #if METAL_DEVICE
    var textureCache: CVMetalTextureCache?
    #endif
    
    // MARK: - Video Delegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
                       from connection: AVCaptureConnection!) {
        #if METAL_DEVICE
        guard let textureCache = textureCache else {
            print("Missing texture cache!")
            return
        }
            
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Couldn't get image buffer")
            return
        }
        
        var optionalTextureRef: CVMetalTexture? = nil
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let returnValue = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                    textureCache,
                                                                    imageBuffer,
                                                                    nil,
                                                                    .bgra8Unorm,
                                                                    width, height, 0,
                                                                    &optionalTextureRef)
        
        guard returnValue == kCVReturnSuccess, let textureRef = optionalTextureRef else {
            print("Error, couldn't create texture from image, error: \(returnValue), \(optionalTextureRef)")
            return
        }
        
        guard let texture = CVMetalTextureGetTexture(textureRef) else {
            print("Error, Couldn't get texture")
            return
        }
        
        self.texture = texture
        #endif
    }
    
    func renderTextureQuad(renderEncoder: MTLRenderCommandEncoder, view: MTKView, identifier: String) {
        guard let texture = texture else {
            return
        }
        renderEncoder.pushDebugGroup(identifier)
        // Set the pipeline state so the GPU knows which vertex and fragment function to invoke.
        renderEncoder.setRenderPipelineState(renderPipelineState)
        renderEncoder.setFrontFacing(.counterClockwise)
        
        // Bind the buffer containing the array of vertex structures so we can
        // read it in our vertex shader.
        renderEncoder.setVertexBuffer(vertexBuffer, offset:0, at:0)
        renderEncoder.setVertexBuffer(textureCoordinatesBuffer, offset: 0, at: 1)
        renderEncoder.setFragmentTexture(texture, at: 0)
        renderEncoder.setFragmentSamplerState(sampler, at: 0)
        renderEncoder.drawPrimitives(type: .triangle,
                                     vertexStart: 0,
                                     vertexCount: 6,
                                     instanceCount: 1)
        renderEncoder.popDebugGroup()
    }
    
    // MARK: - Buffer Updates
    
    #if os(macOS)
    func invalidateVertexBuffer() {
        let contents = vertexBuffer.contents()
        memcpy(contents, vertices, MemoryLayout<Vertex>.stride * vertices.count)
        let length = vertexBuffer.length
        let range = NSRange(location: 0, length: length)
        vertexBuffer.didModifyRange(range)
    }
    
    func invalidateTextureCoordinatesBuffer() {
        let contents = textureCoordinatesBuffer.contents()
        memcpy(contents, textureCoordinates, MemoryLayout<float2>.stride * textureCoordinates.count)
        let length = textureCoordinatesBuffer.length
        let range = NSRange(location: 0, length: length)
        textureCoordinatesBuffer.didModifyRange(range)
    }
    #endif
    
    // MARK: - Shader Updates

    func updateShader(withLibrary library: MTLLibrary,
                      shaderFunction functionName: String) {
        guard let fragmentFunction = library.makeFunction(name: functionName) else {
            print("Failed to make fragment function: \(functionName)")
            return
        }
        
        do {
            let pipeline = try buildRenderPipeline(withFragmentFunction: fragmentFunction)
            renderPipelineState = pipeline
            
        } catch {
            print("Error updating shader: \(error)")
        }
        
    }
    
    // MARK: - Camera Controller Handlers
    
    func captureHandler(imageBuffer: CVImageBuffer) {
        #if METAL_DEVICE
        guard let textureCache = textureCache else {
            print("Missing texture cache!")
            return
        }
        var optionalTextureRef: CVMetalTexture? = nil
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let returnValue = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                    textureCache,
                                                                    imageBuffer,
                                                                    nil,
                                                                    .bgra8Unorm,
                                                                    width, height, 0,
                                                                    &optionalTextureRef)
        
        guard returnValue == kCVReturnSuccess, let textureRef = optionalTextureRef else {
            print("Error, couldn't create texture from image, error: \(returnValue), \(optionalTextureRef)")
            return
        }
        
        guard let texture = CVMetalTextureGetTexture(textureRef) else {
            print("Error, Couldn't get texture")
            return
        }
        
        self.texture = texture
        view.draw()
        #endif
    }
    
    // MARK: - Metal View Delegate
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // respond to resize
    }
    
    @objc(drawInMTKView:)
    func draw(in metalView: MTKView) {
        render(metalView)
    }
    
    // MARK: - Metal Performance Shaders
    
    
    func blurTexture(withCommandBuffer commandBuffer: MTLCommandBuffer, textureIn: MTLTexture, textureOut: MTLTexture) {
        let blurEncoder = MPSImageGaussianBlur(device: commandBuffer.device, sigma: 5.0)
        blurEncoder.encode(commandBuffer: commandBuffer, sourceTexture: textureIn, destinationTexture: textureOut)
    }
    
    func blurTextureInPlace(withCommandBuffer commandBuffer: MTLCommandBuffer, texture: inout MTLTexture) {
        let copyAllocator: MPSCopyAllocator = { kernel, commandBuffer, sourceTexture -> MTLTexture in
            let format = sourceTexture.pixelFormat
            let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: format,
                                                                      width: sourceTexture.width,
                                                                      height: sourceTexture.height, mipmapped: false)
            let newTexture = commandBuffer.device.makeTexture(descriptor: descriptor)
            print("copy allocator!")
            return newTexture
        }
        
        let blurEncoder = MPSImageGaussianBlur(device: commandBuffer.device, sigma: 5.0)
        blurEncoder.encode(commandBuffer: commandBuffer,
                           inPlaceTexture: &texture,
                           fallbackCopyAllocator: copyAllocator)
    }
}

// MARK: - Callbacks

fileprivate struct Method {
    static let captureHandler = Renderer.captureHandler
}

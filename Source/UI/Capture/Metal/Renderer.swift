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
    let cameraController: MetalCameraController
    
    init?(metalView: MTKView) {
        view = metalView
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
        guard let cameraController = MetalCameraController(device: device) else {
            print("Camera controller initialization failed")
            return nil
        }
        self.cameraController = cameraController
        super.init()
        
        do {
            renderPipelineState = try buildRenderPipeline()
        } catch {
            print("Unable to compile render pipeline state")
            return nil
        }
        
        cameraController.setTextureHandler(instance: self,
                                           method: Method.textureHandler)
        cameraController.startCapturingVideo()
        setUpMetalView()
    }
    
    // MARK: - Startup
    
    func setUpMetalView() {
        // MetalPerformanceShaders are a compute framework
        // Drawable texture is written to, not rendered to
        view.framebufferOnly = false
        // Draw loop is managed manually whenever new frame is received
        view.isPaused = true
        view.delegate = self
        view.device = device
        view.clearColor = MTLClearColorMake(1, 1, 1, 1)
        view.colorPixelFormat = .bgra8Unorm
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
        
        return (library: library,
                vertexFunction: vertexFunction,
                fragmentFunction: fragmentFunction)
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
        guard let texture = self.texture else {
            return
        }
        // Our command buffer is a container for the work we want to perform with the GPU.
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        guard let currentDrawable = view.currentDrawable else {
            fatalError("no drawable!")
        }
        #if METAL_DEVICE
        let newTexture = filterTexture(texture, withCommandBuffer: commandBuffer)
        renderFullScreen(commandBuffer: commandBuffer,
                         drawable: currentDrawable,
                         inputTexture: newTexture)
        #endif
        
        // Tell the system to present the cleared drawable to the screen.
        commandBuffer.present(currentDrawable)
        
        // Now that we're done issuing commands, we commit our buffer so the GPU can get to work.
        commandBuffer.commit()
    }
    
    lazy var filter: ChromaticAberrationFilter = {
       return ChromaticAberrationFilter(device: self.device)
    }()
    
    func filterTexture(_ texture: MTLTexture,
                       withCommandBuffer commandBuffer: MTLCommandBuffer) -> MTLTexture {
        return filter.filter(withCommandBuffer: commandBuffer, inputTexture: texture)
    }
    
    #if METAL_DEVICE
    func renderFullScreen(commandBuffer: MTLCommandBuffer,
                          drawable: CAMetalDrawable,
                          inputTexture texture: MTLTexture) {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1)
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .dontCare
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
    
        // Create a render encoder to clear the screen and draw our objects
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        renderTextureQuad(renderEncoder: renderEncoder,
                          view: view,
                          identifier: "video texture",
                          inputTexture: texture)
        
        // We are finished with this render command encoder, so end it.
        renderEncoder.endEncoding()
    }
    #endif
    
    // MARK: - Video Rendering
    
    var texture: MTLTexture?
    func renderTextureQuad(renderEncoder: MTLRenderCommandEncoder,
                           view: MTKView,
                           identifier: String,
                           inputTexture texture: MTLTexture) {
        renderEncoder.pushDebugGroup(identifier)
        // Set the pipeline state so the GPU knows which vertex and fragment function to invoke.
        renderEncoder.setRenderPipelineState(renderPipelineState)
        renderEncoder.setFrontFacing(.counterClockwise)
        
        // Bind the buffer containing the array of vertex structures so we can
        // read it in our vertex shader.
        renderEncoder.setVertexBuffer(vertexBuffer, offset:0, at:0)
        renderEncoder.setVertexBuffer(textureCoordinatesBuffer, offset: 0, at: 1)
        renderEncoder.setFragmentTexture(texture, at: 0)
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
    
    // MARK: - Camera Controller Handler
    
    func textureHandler(texture: MTLTexture) {
        self.texture = texture
        view.draw()
    }
    
    // MARK: - Metal View Delegate
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // respond to resize
    }
    
    @objc(drawInMTKView:)
    func draw(in metalView: MTKView) {
        render(metalView)
    }
}

// MARK: - Callbacks

fileprivate struct Method {
    static let textureHandler = Renderer.textureHandler
}

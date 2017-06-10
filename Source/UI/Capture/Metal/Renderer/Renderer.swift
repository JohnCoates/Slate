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
        
        guard let cameraController = MetalCameraController(device: device) else {
            print("Camera controller initialization failed")
            return nil
        }
        self.cameraController = cameraController
        
        vertexBuffer = Renderer.generateQuad(forDevice: device,
                                             inArray: &vertices,
                                             inputSize: cameraController.inputSize)
        textureCoordinatesBuffer = Renderer.generate(textureCoordinates: &textureCoordinates, forDevice: device)
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
    
    func buildRenderPipeline(withFragmentFunction passedFragmentFunction: MTLFunction? = nil) throws
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
    
    var useFilters = false
    lazy var filter: AbstractFilter = {
//       return ChromaticAberrationFilter(device: self.device)
//        return ChromaticAberrationFragmentFilter(device: self.device)
        return GaussianBlurFilter(device: self.device)
    }()
    
    lazy var filters: [AbstractFilter] = {
        return [self.filter]
    }()
    
    func filterTexture(_ texture: MTLTexture,
                       withCommandBuffer commandBuffer: MTLCommandBuffer) -> MTLTexture {
        return filters.reduce(texture) { currentTexture, filter in
            filter.filter(withCommandBuffer: commandBuffer, inputTexture: currentTexture)
        }
    }
    
    #if METAL_DEVICE
    func renderFullScreen(commandBuffer: MTLCommandBuffer,
                          drawable: CAMetalDrawable,
                          inputTexture texture: MTLTexture) {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1)
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
    
        // Create a render encoder to clear the screen and draw our objects
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder.setFragmentSamplerState(sampler, at: 0)
        
        renderTextureQuad(renderEncoder: renderEncoder,
                          view: view,
                          identifier: "video texture",
                          inputTexture: texture)
        // We are finished with this render command encoder, so end it.
        renderEncoder.endEncoding()
    }
    #endif
    
    // MARK: - Command Buffer
    
    var verticesUpdate: [Vertex]?
    var textureCoordinatesUpdate: [float2]?    
    
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
    
    // MARK: - Camera Controller Handler
    
    var dirtyTexture = false
    func textureHandler(texture: MTLTexture) {
        self.texture = texture
        dirtyTexture = true
    }
    
    // MARK: - Metal View Delegate
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        updateTextureCoordinates(withViewSize: size)
    }
    
    @objc(drawInMTKView:)
    func draw(in metalView: MTKView) {
        render(toView: metalView)
    }
    
    // MARK: - Texture Sampling
    
    lazy var sampler: MTLSamplerState = Renderer.makeSampler(withDevice: self.device)
}

// MARK: - Callbacks

fileprivate struct Method {
    static let textureHandler = Renderer.textureHandler
}

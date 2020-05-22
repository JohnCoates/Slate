#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position;
};

struct TextureCoordinatesIn {
    float2 textureCoordinates [[user(texturecoord)]];
};

struct VertexOut {
    float4 position [[position]];
    float2 textureCoordinates [[user(texturecoord)]];
};

// passthrough

vertex VertexOut vertexPassthrough(const device VertexIn *vertices [[ buffer(0) ]],
                                   const device float2 *textureCoordinates [[ buffer(1) ]],
                                   uint vertexID [[ vertex_id ]]) {
    VertexOut out;
    out.position = vertices[vertexID].position;
//    out.textureCoordinates = vertices[vertexId].textureCoordinates;
    out.textureCoordinates = textureCoordinates[vertexID];
    return out;
}

fragment float4 fragmentPassthrough(VertexOut fragmentIn [[ stage_in ]],
                                   texture2d<float, access::sample> texture [[texture(0)]]) {
    constexpr sampler qsampler;
    float4 color = texture.sample(qsampler, fragmentIn.textureCoordinates);
    return color;
}

fragment half4 fragmentPassthroughHalf(VertexOut fragmentIn [[ stage_in ]],
                                   texture2d<half> tex [[ texture(0) ]] ) {
    constexpr sampler qsampler;
    half4 color = tex.sample(qsampler, fragmentIn.textureCoordinates);
    return color;
}


fragment float4 fragmentPassthroughWithExistingSampler(VertexOut fragmentIn [[ stage_in ]],
                                                       sampler qsampler [[ sampler(0) ]],
                                    texture2d<float, access::sample> texture [[ texture(0) ]]) {
    return texture.sample(qsampler, fragmentIn.textureCoordinates);
}

// MARK: - Compute

kernel void passthroughComputePixel(texture2d<float, access::read> texture [[texture(0)]],
                               texture2d<float, access::write> outTexture [[texture(1)]],
                               uint2 gid [[thread_position_in_grid]]
                               ) {
    const float4 color = texture.read(gid);
    const float4 outColor = color;
    outTexture.write(outColor, gid);
}


kernel void passthroughComputeNormalized(texture2d<float, access::sample> texture [[texture(0)]],
                                    texture2d<float, access::write> outTexture [[texture(1)]],
                                    uint2 gid [[thread_position_in_grid]]
                                    ) {
    int width = texture.get_width();
    int height = texture.get_height();
    float2 coordinates = float2(gid) / float2(width, height);
    
    constexpr sampler textureSampler(coord::normalized,
                                     address::clamp_to_edge);
    float4 color = texture.sample(textureSampler, coordinates);
    float4 outColor = color;
    outTexture.write(outColor, gid);
}


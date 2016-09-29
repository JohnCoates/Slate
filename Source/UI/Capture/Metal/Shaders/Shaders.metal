#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position;
    float2 textureCoordinates [[user(texturecoord)]];
};

struct VertexOut {
    float4 position [[position]];
    float2 textureCoordinates [[user(texturecoord)]];
};

// passthrough

vertex VertexOut vertexPassthrough(device VertexIn *vertices [[ buffer(0) ]],
                                    uint vertexId [[ vertex_id ]]) {
    VertexOut out;
    out.position = vertices[vertexId].position;
    out.textureCoordinates = vertices[vertexId].textureCoordinates;
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
                                                       sampler qsampler [[sampler(0)]],
                                    texture2d<float, access::sample> texture [[texture(0)]]) {
    return texture.sample(qsampler, fragmentIn.textureCoordinates);
}

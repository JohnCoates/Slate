#include <metal_stdlib>

using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 textureCoordinates [[user(texturecoord)]];
};

fragment float4 fragmentShader(VertexOut fragmentIn [[ stage_in ]],
                                   texture2d<float, access::sample> texture [[texture(0)]]) {
    constexpr sampler qsampler;
    float4 color = texture.sample(qsampler, fragmentIn.textureCoordinates);
    return color;
}

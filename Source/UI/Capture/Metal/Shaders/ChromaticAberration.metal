//
//  ChromaticAberration.metal
//  Slate
//
//  Created by John Coates on 9/30/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

#include <metal_stdlib>

using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 textureCoordinates [[user(texturecoord)]];
};

fragment float4 fragmentShader(VertexOut fragmentIn [[ stage_in ]],
                               texture2d<float, access::sample> texture [[texture(0)]]) {
    float2 coordinates = fragmentIn.textureCoordinates;
    constexpr sampler qsampler;
    float4 color = texture.sample(qsampler, coordinates);
    float2 offset = (coordinates - 0.4) * 2.0;
    float offsetDot = dot(offset, offset);
    
    const float strength = 5.0;
    float2 multiplier = strength * offset * offsetDot;
    float2 redCoordinate = coordinates - 0.003 * multiplier;
    float2 blueCoordinate = coordinates + 0.01 * multiplier;
    float4 adjusted;
    adjusted.r = texture.sample(qsampler, redCoordinate).r;
    adjusted.g = color.g;
    adjusted.b = texture.sample(qsampler, blueCoordinate).b;
    adjusted.a = color.a;
    return adjusted;
}

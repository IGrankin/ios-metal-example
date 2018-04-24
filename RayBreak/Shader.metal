//
//  Shader.metal
//  RayBreak
//
//  Created by Igor Grankin on 01.04.2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct ModelConstants {
    float4x4 modelViewMatrix;
    float3x3 normalMatrix;
    float specularIntensity;
    float shininess;
};

struct SceneConstants {
    float4x4 projectionMatrix;
};

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
    float2 textureCoordinates [[attribute(2)]];
    float3 normal [[attribute(3)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float2 textureCoordinates;
    float3 normal;
    float3 eyePosition;
    float specularIntensity;
    float shininess;
};

struct Light {
    float3 color;
    float ambientIntensity;
    float diffuseIntensity;
    float3 direction;
};

vertex VertexOut vertex_shader(const VertexIn vertexIn [[stage_in]],
                               constant ModelConstants &modelConstants [[buffer(1)]],
                               constant SceneConstants &sceneConstants [[buffer(2)]]) {
    VertexOut vertexOut;
    float4x4 matrix = sceneConstants.projectionMatrix * modelConstants.modelViewMatrix;
    vertexOut.position = matrix * vertexIn.position;
    vertexOut.color = vertexIn.color;
    vertexOut.textureCoordinates = vertexIn.textureCoordinates;
    vertexOut.shininess = modelConstants.shininess;
    vertexOut.specularIntensity = modelConstants.specularIntensity;
    //error
    vertexOut.normal = modelConstants.normalMatrix * vertexIn.normal;
    vertexOut.eyePosition = (modelConstants.modelViewMatrix * vertexIn.position).xyz;
    return vertexOut;
}

fragment half4 fragment_shader(VertexOut vertexIn [[stage_in]]) {
    return half4(vertexIn.color);
}

fragment half4 textured_fragment(VertexOut vertexIn [[stage_in]],
                                 sampler sampler2d [[sampler(0)]],
                                 texture2d<float> texture [[texture(0)]]) {
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    if (color.a == 0.0)
        discard_fragment();
    return half4(color.r, color.g, color.b, 1);
}

fragment half4 textured_mask_fragment(VertexOut vertexIn [[ stage_in ]],
                                      texture2d<float> texture [[ texture(0)]],
                                      texture2d<float> maskTexture [[ texture(1) ]],
                                      sampler sampler2d [[sampler(0)]]) {
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    float4 maskColor = maskTexture.sample(sampler2d, vertexIn.textureCoordinates);
    float maskOpacity = maskColor.a;
    if (maskOpacity < 0.5)
        discard_fragment();
    return half4(color.r, color.g, color.b, 1);
}

fragment half4 lit_textured_fragment(VertexOut vertexIn [[stage_in]],
                                 sampler sampler2d [[sampler(0)]],
                                     constant Light &light [[buffer(3)]],
                                 texture2d<float> texture [[texture(0)]]) {
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    
    //ambient color
    float3 ambientColor = light.color * light.ambientIntensity;
    //diffuse light
    float3 normal = normalize(vertexIn.normal);
    float diffuseFactor = saturate(-dot(normal, light.direction));
    float3 diffuseColor = light.color * light.diffuseIntensity * diffuseFactor;
    // Specular
    float3 eye = normalize(vertexIn.eyePosition);
    float3 reflection = reflect(light.direction, normal);
    float specularFactor = pow(saturate(-dot(reflection, eye)), vertexIn.shininess);
    float3 specularColor = light.color * vertexIn.specularIntensity * specularFactor;
    
    color = color * float4(ambientColor + diffuseColor + specularColor, 1);
    
    if (color.a == 0.0)
        discard_fragment();
    return half4(color.r, color.g, color.b, 1);
}

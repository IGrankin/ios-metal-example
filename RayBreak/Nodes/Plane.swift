//
//  Plane.swift
//  RayBreak
//
//  Created by Igor Grankin on 02.04.2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import MetalKit

class Plane: Primitive {
    override func buildVertices() {
    vertices = [
        Vertex(position: float3(-1, 1, 0), color: float4(1, 0, 0, 1), texture: float2(0, 1)),
        Vertex(position: float3(-1, -1, 0), color: float4(0, 1, 0, 1), texture: float2(0, 0)),
        Vertex(position: float3(1, -1, 0), color: float4(0, 0, 1, 1), texture: float2(1, 0)),
        Vertex(position: float3(1, 1, 0), color: float4(1, 0, 1, 1), texture: float2(1, 1))
    ]
    
    indices = [
        0, 1, 2,
        2, 3, 0]
    }
}

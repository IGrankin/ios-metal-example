//
//  Camera.swift
//  RayBreak
//
//  Created by Igor Grankin on 18.04.2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import MetalKit

class Camera: Node {
    var viewMatrix: matrix_float4x4 {
        return modelMatrix
    }
    
    var fovDegrees: Float = 65
    var fovRadians: Float {
        return radians(fromDegrees: fovDegrees)
    }
    var aspect: Float = 1
    var nearZ: Float = 0.1
    var farZ: Float = 100
    
    var projectionMatrix: matrix_float4x4 {
        return matrix_float4x4(projectionFov: fovRadians,
                               aspect: aspect,
                               nearZ: nearZ,
                               farZ: farZ)
    }
}

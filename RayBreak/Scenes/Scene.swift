//
//  Scene.swift
//  RayBreak
//
//  Created by Igor Grankin on 02.04.2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import MetalKit

class Scene: Node {
    var device: MTLDevice
    var size: CGSize
    var camera = Camera()
    var sceneConstants = SceneConstants()
    var light = Light()
    
    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        super.init()
        camera.aspect = Float(size.width / size.height)
        camera.position.z = -6
        add(childNode: camera)
        light.color = float3(0, 0, 1)
        light.ambientIntensity = 0.5
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder,
                deltaTime: Float) {
        update(deltaTime: deltaTime)
        sceneConstants.projectionMatrix = camera.projectionMatrix
        commandEncoder.setFragmentBytes(&light, length: MemoryLayout<Light>.stride, at: 3)
        commandEncoder.setVertexBytes(&sceneConstants,
                                      length: MemoryLayout<SceneConstants>.stride,
                                      at: 2)
        for child in children {
            child.render(commandEncoder: commandEncoder,
                         parentModelViewMatrix: camera.viewMatrix)
        }
    }
    
    func update(deltaTime: Float) {}
    
    func touchesBegan(_ view: UIView, touches: Set<UITouch>,
                      with event: UIEvent?) {}
    func touchesMoved(_ view: UIView, touches: Set<UITouch>,
                      with event: UIEvent?) {}
    func touchesEnded(_ view: UIView, touches: Set<UITouch>,
                      with event: UIEvent?) {}
    func touchesCancelled(_ view: UIView, touches: Set<UITouch>,
                          with event: UIEvent?) {}
}

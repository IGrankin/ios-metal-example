//
//  LightningScene.swift
//  RayBreak
//
//  Created by Igor Grankin on 22.04.2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import MetalKit

class LightningScene: Scene {
    let cube: Model
    var room: Model
    var previousTouchLocation: CGPoint = .zero
    override init(device: MTLDevice, size: CGSize) {
        cube = Model(device: device, modelName: "texturedCube")
        room = Model(device: device, modelName: "texturedCube")
        super.init(device: device, size: size)
        cube.position.y = -1
        cube.specularIntensity = 0.5
        cube.shininess = 2.0
        room.scale = float3(10)
        room.position.y = 7
        add(childNode: cube)
        add(childNode: room)
        
        light.color = float3(1, 1, 1)
        light.ambientIntensity = 0.4
        light.diffuseIntensity = 0.8
        light.direction = float3(0, 0, -1)
    }
    
    override func update(deltaTime: Float) {
    }
    
    override func touchesBegan(_ view: UIView, touches: Set<UITouch>,
                               with event: UIEvent?) {
        guard let touch = touches.first else { return }
        previousTouchLocation = touch.location(in: view)
    }
    override func touchesMoved(_ view: UIView, touches: Set<UITouch>,
                               with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: view)
        let delta = CGPoint(x: previousTouchLocation.x - touchLocation.x,
                            y: previousTouchLocation.y - touchLocation.y)
        let sensitivity: Float = 0.01
        cube.rotation.x += Float(delta.y) * sensitivity
        cube.rotation.y += Float(delta.x) * sensitivity
        previousTouchLocation = touchLocation
    }
}


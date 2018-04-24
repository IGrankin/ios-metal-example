//
//  GameScene.swift
//  RayBreak
//
//  Created by Igor Grankin on 02.04.2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import MetalKit

class GameScene: Scene {
    let mushroom: Model
    override init(device: MTLDevice, size: CGSize) {
        mushroom = Model(device: device, modelName: "mushroom")
        super.init(device: device, size: size)
        add(childNode: mushroom)
        camera.position.z = -6
//        camera.rotation.x = radians(fromDegrees: 45)
//        camera.rotation.y = radians(fromDegrees: 45)
    }
    
    override func update(deltaTime: Float) {
        mushroom.rotation.y += deltaTime
    }
}

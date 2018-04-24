//
//  Texturable.swift
//  RayBreak
//
//  Created by Igor Grankin on 14.04.2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import MetalKit

protocol Texturable {
    var texture: MTLTexture? {get set}
    
}

extension Texturable {
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: device)
        var texture: MTLTexture? = nil
        let textureLoaderOptions: [String: NSObject]
        if #available(iOS 10.0, *) {
            let origin = NSString(string: MTKTextureLoaderOriginBottomLeft)
            textureLoaderOptions = [MTKTextureLoaderOptionOrigin: origin]
        } else {
            textureLoaderOptions = [:]
        }
        
        if let textureURL = Bundle.main.url(forResource: imageName, withExtension: nil) {
            do {
                texture = try textureLoader.newTexture(withContentsOf: textureURL, options: textureLoaderOptions)
            } catch {
                print("Texture not loaded")
            }
        }
        return texture
    }
}

//
//  ViewController.swift
//  RayBreak
//
//  Created by Igor Grankin on 25.03.2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import UIKit
import MetalKit

enum Colors {
    static let wenderlichGreen = MTLClearColor(red: 0.0, green: 0.4, blue: 0.21, alpha: 1.0)
}

class ViewController: UIViewController {

    @IBOutlet var stepper: UIStepper!
    @IBAction func stepperPressed(_ sender: Any) {
        renderer?.scene?.camera.position.z = Float(stepper.value)
    }
    var renderer: Renderer?
    
    var metalView: MTKView {
        return view as! MTKView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalView.device = MTLCreateSystemDefaultDevice()
        guard let device = metalView.device else {
            fatalError("Device not created! Run on a physical device.")
        }
        metalView.depthStencilPixelFormat = .depth32Float
        metalView.clearColor = Colors.wenderlichGreen
        renderer = Renderer(device: device)
        renderer?.scene = LightningScene(device: device, size: view.bounds.size)
        metalView.delegate = renderer
       stepper.autorepeat = true
        var value = Double((renderer?.scene?.camera.position.z)!)
        stepper.value = value
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        renderer?.scene?.touchesBegan(view, touches:touches,
                                      with: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        renderer?.scene?.touchesMoved(view, touches: touches,
                                      with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        renderer?.scene?.touchesEnded(view, touches: touches,
                                      with: event)
    }
    override func touchesCancelled(_ touches: Set<UITouch>,
                                   with event: UIEvent?) {
        renderer?.scene?.touchesCancelled(view, touches: touches,
                                          with: event)
    }

}



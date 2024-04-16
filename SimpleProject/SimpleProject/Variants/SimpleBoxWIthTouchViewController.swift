//
//  SimpleBoxWIthTouchViewController.swift
//  SimpleBox
//
//  Created by Conner Maddalozzo on 4/2/24.
//
//  ViewController.swift
//  SimpleBox
//
//  Created by Conner Maddalozzo on 3/14/24.
//

import UIKit
import SceneKit
import ARKit

class SimpleBoxWIthTouchViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        let geometry = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0)
        let material = SCNMaterial()
        material.name = "Hit Test"
        material.diffuse.contents = UIColor.purple
        
        geometry.materials = [material]
        let boxNode = SCNNode(geometry: geometry)
        // 0.5 units away from the camera
        boxNode.position = .init(x: 0, y: 0, z: -0.5)
        
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDap))
        
        self.sceneView.scene.rootNode.addChildNode(boxNode)
        self.sceneView.addGestureRecognizer(tapGesture)
    }
    @objc
    func didDap(_ gesture: UIGestureRecognizer) {
        guard let sceneView = gesture.view as? SCNView else { return }
        
        let touchLocation = gesture.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitResults.isEmpty {
            let node = hitResults[0].node
            let material = node.geometry?.material(named: "Hit Test")
            material?.diffuse.contents = UIColor.random
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
public extension UIColor {
    static var random: UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
    }
}

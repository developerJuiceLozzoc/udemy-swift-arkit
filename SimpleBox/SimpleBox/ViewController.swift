//
//  ViewController.swift
//  SimpleBox
//
//  Created by Conner Maddalozzo on 3/14/24.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

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
        material.diffuse.contents = UIColor.purple
        
        geometry.materials = [material]
        let boxNode = SCNNode(geometry: geometry)
        // 0.5 units away from the camera
        boxNode.position = .init(x: 0, y: 0, z: -0.5)
        
        
        // Set the scene to the view
        sceneView.scene = scene
        
        self.sceneView.scene.rootNode.addChildNode(boxNode)
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

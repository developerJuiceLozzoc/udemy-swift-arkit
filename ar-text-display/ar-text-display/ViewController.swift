//
//  ViewController.swift
//  ar-text-display
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
        sceneView.scene = scene

        
        let geometry = SCNText(string: "hello world", extrusionDepth: 1.0)
        
        geometry.extrusionDepth = 1.0
        
        
        geometry.firstMaterial?.diffuse.contents = UIColor.purple
        
        let node = SCNNode(geometry: geometry)
        node.position = .init(x: 0, y: 0, z: -0.5)
        node.scale = .init(x: 0.02, y: 0.02, z: 0.02)
        sceneView.scene.rootNode.addChildNode(node)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            geometry.string = "hello"
        }
        
        
        // Set the scene to the view
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

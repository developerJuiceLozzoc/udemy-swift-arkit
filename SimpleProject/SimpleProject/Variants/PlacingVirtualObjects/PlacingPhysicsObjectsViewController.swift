//
//  PlacingPhysicsObjectsViewController.swift
//  SimpleProject
//
//  Created by Conner Maddalozzo on 4/7/24.
//

import UIKit
import ARKit
import SceneKit

enum BodyTypeBitmask: Int {
    case box = 1
    case plane = 2 
}

class PlacingPhysicsObjectsViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label.frame = CGRect(x: 0, y: 0, width: self.sceneView.frame.size.width, height: 44)
        self.label.center = self.sceneView.center
        self.label.textAlignment = .center
        self.label.textColor = UIColor.white
        self.label.font = UIFont.preferredFont(forTextStyle: .headline)
        self.label.alpha = 0
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didDap)))
        sceneView.scene = scene
        
        self.sceneView.addSubview(self.label)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @objc
    func didDap(_ gesture: UIGestureRecognizer) {
        guard let sceneView = gesture.view as? ARSCNView else { return }
        
        let touchLocation = gesture.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        if let hitResult = hitResults.first {
           addBox(onto: hitResult)
        }
    }
    
    private func addBox(onto hitResult: ARHitTestResult) {
        
        // start putting in geometrys
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.random
        let x = hitResult.worldTransform.columns.3.x
        let z = hitResult.worldTransform.columns.3.z //offset
        let y = hitResult.worldTransform.columns.3.y + Float(box.height/2) + 0.5

        let boxNode = SCNNode(geometry: box)
        
        boxNode.position = .init(0, 0, -0.5)
        boxNode.geometry?.materials = [material]
        boxNode.position = SCNVector3Make(x, y, z)
        
        
        
        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        boxNode.physicsBody?.categoryBitMask = BodyTypeBitmask.box.rawValue
        // dynamic veruss kinematic? apparently static does push thingg back? or does it clip through?
        
        sceneView.scene.rootNode.addChildNode(boxNode)

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private let label :UILabel = UILabel()
    private var planes = [OverlayPlane]()

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let plane = self.planes.first(where: { $0.identifier == anchor.identifier }) else { return }
        plane.update(anchor: anchor as! ARPlaneAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            let plane = OverlayPlane(onTopOf: anchor as! ARPlaneAnchor)
            planes.append(plane)
            node.addChildNode(plane)
        }
        
        DispatchQueue.main.async {
            self.label.text = "Plane Detected"
            
            
            
            UIView.animate(withDuration: 3.0) {
                self.label.alpha = 1.0
            } completion: { completionBool in
                self.label.alpha = 0
            }
        }
    }

}

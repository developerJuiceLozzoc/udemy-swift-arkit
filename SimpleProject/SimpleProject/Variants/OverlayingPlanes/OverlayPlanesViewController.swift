//
//  OverlayPlanesViewController.swift
//  SimpleProject
//
//  Created by Conner Maddalozzo on 4/2/24.
//

import UIKit
import ARKit
import SceneKit

class OverlayPlanesViewController: UIViewController, ARSCNViewDelegate {
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
        guard let sceneView = gesture.view as? SCNView else { return }
        
        let touchLocation = gesture.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitResults.isEmpty {
            let node = hitResults[0].node
            let material = node.geometry?.material(named: "Hit Test")
            material?.diffuse.contents = UIColor.random
        }
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

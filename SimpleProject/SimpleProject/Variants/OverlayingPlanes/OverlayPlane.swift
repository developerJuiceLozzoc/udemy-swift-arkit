//
//  OverlayPlane.swift
//  SimpleProject
//
//  Created by Conner Maddalozzo on 4/2/24.
//

//
//  Plane.swift
//  ARGraph
//
//  Created by Mohammad Azam on 6/13/17.
//  Copyright © 2017 Mohammad Azam. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class OverlayPlane : SCNNode {
    
    var anchor: ARPlaneAnchor
    var scenePlane: SCNPlane!
    var identifier = UUID()
    
    init(onTopOf anchor: ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("classic required init")
    }
    
    public func update(anchor: ARPlaneAnchor) {
        self.scenePlane.width = CGFloat(anchor.extent.x)
        self.scenePlane.height = CGFloat(anchor.extent.z)
        self.position = SCNVector3Make((anchor.center.x), 0, anchor.center.z)
        let planeNode = self.childNodes.first!
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.scenePlane))
        planeNode.physicsBody?.categoryBitMask =  BodyTypeBitmask.plane.rawValue // there is no plane body type in scope.
    }
    
    private func setup() {
        self.scenePlane = SCNPlane(width: CGFloat(self.anchor.extent.x), height: CGFloat(self.anchor.extent.z))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "overlay_grid")
        self.scenePlane.materials = [material]
        
        let planeNode = SCNNode(geometry: scenePlane)
        planeNode.physicsBody = .init(type: .static, shape: SCNPhysicsShape(geometry: self.scenePlane))
        planeNode.physicsBody?.categoryBitMask =  BodyTypeBitmask.plane.rawValue // there is no plane body type in scope.
        
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation((-Float.pi / 2.0), 1.0, 0.0, 0)
        
        self.addChildNode(planeNode)
        
        
    }
}


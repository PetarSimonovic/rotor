//
//  CollisionDetector.swift
//  rotor
//
//  Created by Petar Simonovic on 30/05/2023.
//

import Foundation
import SceneKit

class CollisionDetector: NSObject, SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("** Collision!! " + contact.nodeA.name! + " hit " + contact.nodeB.name!)

    }
    
}

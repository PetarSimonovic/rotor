//
//  Extensions.swift
//  rotor
//
//  Created by Petar Simonovic on 01/05/2023.
//

import Foundation
import SceneKit

extension SCNNode {
    
    func placeInFrontOfNode(inFrontOf node: SCNNode, atDistance distance: Float) -> SCNVector3 {
        let localPosition = SCNVector3(x: 0, y: 0, z: Float(CGFloat(-distance)))
        let scenePosition = node.convertPosition(localPosition, to: nil)
             // to: nil is automatically scene space
        return scenePosition
    }
}

//
//  DiscCreator.swift
//  rotor
//
//  Created by Petar Simonovic on 17/03/2024.
//

import Foundation
import SceneKit

class DiscCreator {
    
    
    func generate(radius: Float, height: Float) -> SCNNode {
        let disc = SCNCylinder(radius: CGFloat(radius), height: CGFloat(height))

        disc.firstMaterial?.diffuse.contents = setColour()
        return SCNNode(geometry: disc)
    }
    
    func setColour() -> UIColor  {
        let red: CGFloat = 0.26 // replace with your red value
        let green: CGFloat = 0.504 // replace with your green value
        let blue: CGFloat = 6.608 // replace with your blue value
        let alpha: CGFloat = 1.0 // replace with your alpha value

        let colour = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return colour

    }
 }


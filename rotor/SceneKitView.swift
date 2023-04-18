//
//  SceneKitView.swift
//  rotor
//
//  Created by Petar Simonovic on 18/04/2023.
//

import SwiftUI
import SceneKit

struct SceneKitView : UIViewRepresentable {
    // Base Node
    let scene = SCNScene()
    
    // makeUIVIew and updateUIView are required to conform to the UIViewRepresentable protocol

    func makeUIView(context: Context) -> SCNView {
           
         // Create a box
         let boxGeometry = SCNBox(width: 5.0, height: 5.0, length: 5.0, chamferRadius: 1.0)
         let boxNode = SCNNode(geometry: boxGeometry)
        
        // add the box to the node.
         scene.rootNode.addChildNode(boxNode)
           
        // attach the scene to the SceneView?
    
        
        let scnView = SCNView()
        scnView.autoenablesDefaultLighting = true
        scene.rootNode.addChildNode(createAmbientLigths())
        scene.rootNode.addChildNode(createOmniLight())

        return scnView

       
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = scene

        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true

        // show statistics such as fps and timing information
        scnView.showsStatistics = true

        // configure the view
        scnView.backgroundColor = UIColor.black
    }
    
    // LIGHTING METHODS
    
    func createAmbientLigths() -> SCNNode {
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        return ambientLightNode
    }
    
    func createOmniLight() -> SCNNode {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        return omniLightNode
    }
}

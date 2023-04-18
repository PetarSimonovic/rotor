//
//  SceneKitView.swift
//  rotor
//
//  Created by Petar Simonovic on 18/04/2023.
//

import SwiftUI
import SceneKit

struct SceneKitView : UIViewRepresentable { // makeUIVIew and updateUIView are required to conform to the UIViewRepresentable protocol
    // Base Node
    let scene = SCNScene()

    func makeUIView(context: Context) -> SCNView {
           
         // Create a box
         let boxGeometry = SCNBox(width: 5.0, height: 5.0, length: 5.0, chamferRadius: 1.0)
         let boxNode = SCNNode(geometry: boxGeometry)
        
        // add the box to the node.
         scene.rootNode.addChildNode(boxNode)
           
        // attach the scene to the SceneView?
        
        let scnView = SCNView()
        scnView.scene = scene
        scnView.autoenablesDefaultLighting = true
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
}

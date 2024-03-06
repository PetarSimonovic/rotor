//
//  SceneKitView.swift
//  rotor
//
//  Created by Petar Simonovic on 18/04/2023.
//

import SwiftUI
import SceneKit
import CoreGraphics

struct LandscapeView : UIViewRepresentable {
    
    // Base Node
    let scene = SCNScene()
    var playerNode = SCNNode()
    
  //  @Binding var jumpCount: Int

    
    
    let allowCameraControl: Bool = true
    
    var size: Int

    
    // makeUIVIew and updateUIView are required to conform to the UIViewRepresentable protocol

    func makeUIView(context: Context) -> SCNView {
        print("Size")
        print(size)
        configurePlayerNode()
        var landscapeGenerator = LandscapeGenerator()


        let landscapeNode: SCNNode = landscapeGenerator.generate(size: size)

        let lookAtNode = SCNNode()
        playerNode.position = SCNVector3(5, 2.0, 5)
        lookAtNode.position = landscapeNode.boundingBox.max
        
        scene.rootNode.addChildNode(lookAtNode)
        
        let constraint = SCNLookAtConstraint(target: lookAtNode)
        constraint.isGimbalLockEnabled = true
        playerNode.constraints = [constraint]
//
        scene.rootNode.addChildNode(landscapeNode)
        landscapeNode.physicsBody?.friction = 1.0


        scene.rootNode.addChildNode(playerNode)
        
        // Create Lights
        
        createAmbientLight()
        createOmniLight()
        
        // Configure Camera
     


        
        let scnView = SCNView()
        scnView.pointOfView = playerNode
        scnView.scene = scene
        return scnView

       
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        
        // updates the scnView with the scene
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        
    
        scnView.allowsCameraControl = allowCameraControl


        // configure the view
        scnView.backgroundColor = UIColor(red: 0.1, green: 0.3, blue: 0.56, alpha: 0.61)
    }
    
    // LIGHTING METHODS
    
    func createAmbientLight() {
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
    }
    
    func createOmniLight() {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
    }
    
    // PLAYER METHODS
    
    
    func configurePlayerNode() {
        
        
    
        playerNode.camera = SCNCamera()
        playerNode.camera?.zFar = 150000
        playerNode.scale = SCNVector3(2, 2, 2)
        
        

    }
    
    
    
    
    
    // EXPERIMENTS
    
    // cribbed from https://movingparts.io/gradient-meshes
    
    func grassTile() -> SCNNode {
        
        let vertexList: [SCNVector3] = [
            SCNVector3(-1, -1, 1), // p00
            SCNVector3( 1, -1, 1), // p10
            SCNVector3( 1, 1, 1),  // p11

    
        ]

        let colorList: [SCNVector3] = [
            SCNVector3(0.846, 0.035, 0.708), // magenta
            SCNVector3(0.001, 1.000, 0.603), // cyan
            SCNVector3(0.006, 0.023, 0.846), // blue

    ]

        let vertices = SCNGeometrySource(vertices: vertexList)
        let indices = vertexList.indices.map(Int32.init)
        let colors = SCNGeometrySource(colors: colorList)
        let elements = SCNGeometryElement(
            indices: indices,
            primitiveType: .triangles
        )

        return SCNNode(
            geometry: SCNGeometry(
                sources: [vertices, colors],
                elements: [elements]
            )
        )

    }
}



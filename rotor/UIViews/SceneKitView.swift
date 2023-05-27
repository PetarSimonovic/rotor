//
//  SceneKitView.swift
//  rotor
//
//  Created by Petar Simonovic on 18/04/2023.
//

import SwiftUI
import SceneKit
import CoreGraphics

struct SceneKitView : UIViewRepresentable {
    
    @EnvironmentObject var iosConnector: iOSConnector
    // Base Node
    let scene = SCNScene()
    var playerNode = SCNNode()
    
  //  @Binding var jumpCount: Int

    
    let landscapeGenerator = LandscapeGenerator()
    
    let test: Bool = true
    
    
    // makeUIVIew and updateUIView are required to conform to the UIViewRepresentable protocol

    func makeUIView(context: Context) -> SCNView {
           
//
        configurePlayerNode()
        playerNode.position = SCNVector3Make(20, 2, 10)

        let landscapeNode: SCNNode = landscapeGenerator.generate()
        
        let constraint = SCNLookAtConstraint(target: landscapeNode)
        constraint.isGimbalLockEnabled = true
        playerNode.constraints = [constraint]
        
        scene.rootNode.addChildNode(landscapeNode)
        print(landscapeNode.position)


        scene.rootNode.addChildNode(playerNode)

               
                
        // Create Lights
        
        createAmbientLight()
        createOmniLight()
        
        // Configure Camera
     

        
        let scnView = SCNView()
        scnView.pointOfView = playerNode
        return scnView

       
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        
        // updates the scnView with the scene
        scnView.scene = scene

        // allows the user to manipulate the camera
        
        scnView.allowsCameraControl = test


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
        
        
        let sphereGeometry = SCNSphere(radius: 1)
        let shape = SCNPhysicsShape(geometry: sphereGeometry, options: nil)
        if (!test) {
            let physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
            playerNode.physicsBody = physicsBody
        }
        playerNode.camera = SCNCamera()

    }
    
    func applyThrust() {
        let force = SCNVector3(x: 0, y: 0.5 , z: 0)

        playerNode.physicsBody?.applyForce(force,
                                           at: playerNode.position, asImpulse: true)

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


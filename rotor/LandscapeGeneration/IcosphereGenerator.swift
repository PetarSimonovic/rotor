//
//  IcoSphereGenerator.swift
//  rotor
//
//  Created by Petar Simonovic on 04/05/2023.
//

import Foundation
import SceneKit

struct IcosphereGenerator {
    
    func generate() -> SCNNode {
        
        let elements = SCNGeometryElement(
            indices: createIcosahedronIndices()
            ,
            primitiveType: .triangles
            
        )
        
        let icosahedronVertices = SCNGeometrySource(vertices: createIcosahedronVertices()
        )
        
        
        
        let geometry: SCNGeometry = SCNGeometry(
            sources: [icosahedronVertices],
            elements: [elements] // COLOURS HERE!!!
        )
        
        let icoSphereNode: SCNNode = SCNNode(geometry: geometry)
        
        return icoSphereNode
        
    }
    
    func createIcosahedronVertices() -> [SCNVector3] {
        
        var icoVertices: [SCNVector3] = []
        
        let goldenRatio: CGFloat = (1.0 + sqrt(5.0)) / 2.0
        
        icoVertices.append(SCNVector3(-1,  goldenRatio,  0))
        icoVertices.append(SCNVector3( 1,  goldenRatio,  0))
        icoVertices.append(SCNVector3(-1, -goldenRatio,  0))
        icoVertices.append(SCNVector3( 1, -goldenRatio,  0));
        
        icoVertices.append(SCNVector3(0, -1,  goldenRatio));
        icoVertices.append(SCNVector3( 0,  1,  goldenRatio));
        icoVertices.append(SCNVector3(0, -1, -goldenRatio));
        icoVertices.append(SCNVector3( 0,  1, -goldenRatio));
        
        icoVertices.append(SCNVector3(goldenRatio,  0, -1));
        icoVertices.append(SCNVector3(goldenRatio,  0,  1));
        icoVertices.append(SCNVector3(-goldenRatio,  0, -1));
        icoVertices.append(SCNVector3(-goldenRatio,  0,  1));
        
        return icoVertices
    }
    
    func createIcosahedronIndices() -> [Int32] {
        // create 20 triangles of the icosahedron
        let indices: [Int32] = [
            0, 11, 5,
            0, 5, 1,
            0, 1, 7,
            0, 7, 10,
            0, 10, 11,
            1, 5, 9,
            5, 11, 4,
            11, 10, 2,
            10, 7, 6,
            7, 1, 8,
            3, 9, 4,
            3, 4, 2,
            3, 2, 6,
            3, 6, 8,
            3, 8, 9,
            4, 9, 5,
            2, 4, 11,
            6, 2, 10,
            8, 6, 7,
            9, 8, 1
        ]
        
        return indices
        
    }
}

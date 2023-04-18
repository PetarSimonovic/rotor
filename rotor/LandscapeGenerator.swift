//
//  LandscapeGenerator.swift
//  rotor
//
//  Created by Petar Simonovic on 18/04/2023.
//

import Foundation
import SceneKit
import GameKit


struct LandscapeGenerator {
    
    
    var x = 10;
    var y = 10;
    
    func generate() -> SCNNode {
        let map = makeNoiseMap(x: 10, y: 10)
        var vertexList: [SCNVector3] = []
        
        for xPos in 0...x {
            for yPos in 0 ... y {
                let z = map.value(at: [Int32(xPos), Int32(yPos)])
                vertexList.append(SCNVector3(Float(xPos), Float(yPos), z))
                // Create colours here too
            }
        }
        
        let vertices = SCNGeometrySource(vertices: vertexList)
        let indices = vertexList.indices.map(Int32.init)
        // let colors = SCNGeometrySource(colors: colorList)
        
        let elements = SCNGeometryElement(
            indices: indices,
            primitiveType: .triangles
        )
        
        return SCNNode(
            geometry: SCNGeometry(
                sources: [vertices],
                elements: [elements] // COLOURS HERE!!!
            )
        )

        
    }


    
    
    
    func makeNoiseMap(x: Int, y: Int) -> GKNoiseMap {
        let source = GKPerlinNoiseSource()
        source.persistence = 0.9

        let noise = GKNoise(source)
        let size = vector2(1.0, 1.0)
        let origin = vector2(0.0, 0.0)
        let sampleCount = vector2(Int32(x), Int32(y))

        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
    }

}

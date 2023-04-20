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
    
    
    var xLength = 100
    var zLength = 100
    
    func generate() -> SCNNode {
        let map: GKNoiseMap = makeNoiseMap(x: xLength, z: zLength)
        let vertexList: [SCNVector3] = createVertices(map)
        let vertices = SCNGeometrySource(vertices: vertexList)
        
        let indices: [Int32] = calculateIndices(vertexList)
        let colorList: [SCNVector3] = calculateColors(vertexList)
        
        
        
        
      
        let colors = SCNGeometrySource(colors: colorList)
        
        
        //WINDING ORDER COMPUTERFILE meshes FACE CULLING
        
        // let colors = SCNGeometrySource(colors: colorList)
        
        let elements = SCNGeometryElement(
            indices: indices,
            primitiveType: .triangles
        )
        
        return SCNNode(
            geometry: SCNGeometry(
                sources: [vertices, colors],
                elements: [elements] // COLOURS HERE!!!
            )
        )

        
    }

    func createVertices(_ map: GKNoiseMap) ->  [SCNVector3] {
        
        var vertexList: [SCNVector3] = []
        for x in 1 ... xLength {
            for z in 1 ... zLength {
                let yPos = map.value(at: [Int32(x), Int32(z)])
                print(yPos)
                let xPos = Float(x)
                let zPos = Float(z)
                vertexList.append(SCNVector3(xPos, yPos, zPos))
            }
        }
        
        return vertexList
    }
    
    func calculateIndices(_ vertexList: [SCNVector3]) -> [Int32] {
        
        var indices: [Int32] = []
        var endOfRow = xLength
        var startOfRow = 0
        for index in 0...vertexList.count - 1 {
            var canGoEast = true
            var canGoNorth = true
            var canGoSouth = true
            var canGoWest = true
            let north = index - zLength
            if north < 0 {
                canGoNorth = false
            }
            
            let east = index + 1
            if east >= endOfRow {
                endOfRow += xLength
                startOfRow += xLength
                canGoEast = false
            }
            
            let south = index + zLength
            if south >= vertexList.count
            {
                canGoSouth = false
            }
            
            let west = index - 1
            if west < startOfRow {
                canGoWest = false
            }
            
            
            // North and East
            
            if canGoNorth && canGoEast {
                indices.append(contentsOf: [Int32(index), Int32(north), Int32(east)])
            }
            
            // East and South
        
            if canGoEast && canGoSouth {
                indices.append(contentsOf: [Int32(index), Int32(east), Int32(south)])
            }
            
            // South and West
            if canGoSouth && canGoWest {
                indices.append(contentsOf: [Int32(index), Int32(south), Int32(west)])
            }
            
            //West and North

            if canGoWest && canGoNorth {
                indices.append(contentsOf: [Int32(index), Int32(west), Int32(north)])
            }
        }
        
        return indices

    }
    
    func calculateColors(_ vertexList: [SCNVector3]) -> [SCNVector3] {
        
        var colorList: [SCNVector3] = []
        
        for vertex in vertexList {
            if vertex.y < -0.8
            {
                colorList.append(SCNVector3(0.046, vertex.y, 0.308))
            }
            else if vertex.y > 0.8
            {
                colorList.append(SCNVector3(vertex.y, vertex.y, vertex.y))

            }
            else {
                colorList.append(SCNVector3(0.046, vertex.y + 0.5, 0.308))

            }
        }
        
        return colorList;

    }
    
    func makeNoiseMap(x: Int, z: Int) -> GKNoiseMap {
        let source = GKPerlinNoiseSource()
        source.persistence = 0.7 // determines how smooth the noise, ie how likely it is to change. Higher values create rougher terrain. Keep values below 1.0

        let noise = GKNoise(source)
        let size = vector2(50.0, 50.0)
        let origin = vector2(20.0, 0.0)
        let sampleCount = vector2(Int32(x), Int32(z))

        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
    }

}

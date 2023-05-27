
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
    
    
    var xLength = 500
    var zLength = 500
    var num_vertices_x = 200
    var num_vertices_z = 200
    
    
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
        
        let landscapeGeometry: SCNGeometry = SCNGeometry(
            sources: [vertices, colors],
            elements: [elements] // COLOURS HERE!!!
        )

        
        let landscapeNode: SCNNode = SCNNode(
            geometry: landscapeGeometry
        )
            
        let landscapePhysicsShape = SCNPhysicsShape(geometry: landscapeGeometry, options: nil)
        let landscapePhysicsBody = SCNPhysicsBody(type: .kinematic, shape: landscapePhysicsShape)
        
        landscapeNode.physicsBody = landscapePhysicsBody
        
        print("Done", landscapeNode)
        return landscapeNode
        
        
    }

    func createVertices(_ map: GKNoiseMap) ->  [SCNVector3] {
        
        var vertexList: [SCNVector3] = []
        
        for x in 1 ... xLength {
            for z in 1 ... zLength {
                var yPos = map.value(at: [Int32(x), Int32(z)])
                var step_x = Float(100 / (199))
                var step_z = Float(zLength / (num_vertices_z - 1))

//                if (yPos > -0.7 && yPos < 0.3) {
//                    yPos = yPos/6
//                }
//                if (yPos > 0.3 && yPos < 0.6) {
//                    yPos = yPos/4
//                }
//
//
//                if yPos < -0.95 {
//                    yPos = -0.7
//                }
//                if yPos > 0.7 {
//                    yPos = yPos * 0.05
//                }
                
                // Height shaping
                var W: Float = 0.6; // width of terracing bands
                var k = floor(yPos / W);
                var f = (yPos - k*W) / W;
                var s = min(9 * f, 1.0);
                let shapedYPos = (k+s) * W;
                
                if yPos > 0 {
                    yPos = yPos * shapedYPos
                }
                                
                // X shaping
                
                
                //let amplifiedX = Float(roundedX + round(x))
                



                let xPos = Float(x)
                let zPos = Float(z)
                vertexList.append(SCNVector3(xPos * 0.08, yPos, zPos * 0.08))
            }
        }
        print(vertexList.count)
        print(vertexList[0])

        print(vertexList[1])
        print(vertexList[2])

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
        print(indices[51], indices[52], indices[53])
        return indices

    }
    
    func calculateColors(_ vertexList: [SCNVector3]) -> [SCNVector3] {
        
        var colorList: [SCNVector3] = []
        
        for vertex in vertexList {
            
            if vertex.y <= -3
            {
                colorList.append(SCNVector3(0.026, vertex.y, 0.408))
            }
//            else if vertex.y <= -0.6
//            {
//                colorList.append(SCNVector3(0.94, 0.78, 0.28))
//            }
            else if vertex.y > 1
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
        source.persistence = 0.05 // determines how smooth the noise, ie how likely it is to change. Higher values create rougher terrain. Keep values below 1.0

        let noise = GKNoise(source)
        let size = vector2(15.0, 15.0)
        let origin = vector2(5.0, 5.0)
        let sampleCount = vector2(Int32(x), Int32(z))
        

        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
    }

}

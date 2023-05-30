
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
    
    var xLength: Float = 500.00
    var zLength: Float = 500.00
    
    // resMultiplier is used to calculate resolution when landscape is drawn
    var resolutionMultiplier: Float = 25.00
    
    var treeLine: Float = 0.3
    var seaLevel: Float = -0.55
    var lowLands: Float = 0.01
    
    
    func generate() -> SCNNode {
        let map: GKNoiseMap = makeNoiseMap(x: Int(xLength), z: Int(zLength))
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
        
        let numVertices: Float = xLength * resolutionMultiplier;
        let resolutionMultiple: Float = xLength/numVertices;
        
        var vertexList: [SCNVector3] = []
        
        var cliff: Bool = false
        var cliffCount: Int = 0
        var cliffLength: Int = 0
        
        for x in 1 ... Int(xLength) {
            for z in 1 ... Int(zLength) {
                var yPos = map.value(at: [Int32(x), Int32(z)])
                if !cliff {
                    let cliffChance = Int.random(in: 1...500)
                    if cliffChance == 1 {
                        cliff = true
                        cliffLength = Int.random(in: 1...20)
                    }

                }
              
                // Bottom out the sea

//                if (yPos < seaLevel) {
//                    yPos = yPos + 0.2
//
//                }
                
                // Set the seabed
//                if yPos < seaLevel {
//                    yPos = seaLevel
//                }
                
                
                // Flatten plains
                if (yPos > seaLevel && yPos < lowLands) {
                    yPos = yPos / 2                }
//
//
//                if yPos < -0.95 {
//                    yPos = -0.7
//                }
                
                // Jagged peaks
                //                if  yPos < treeLine {
//                    yPos = yPos * 0.6
//                    if cliffCount > cliffLength {
//                        print("Cliff reset")
//                        cliff = false
//                        cliffCount = 0
//                        cliffLength = 0
//                    }
//                }
                
            //    if yPos < treeLine
                
                //Cliff
                
        
                
                // Canyons shaping
//                var W: Float = 0.6; // width of terracing bands
//                var k = floor(yPos / W);
//                var f = (yPos - k*W) / W;
//                var s = min(9 * f, 1.0);
//                let shapedYPos = (k+s) * W;
                
//                yPos = yPos * shapedYPos
                
                                
                // X shaping
                
                
                //let amplifiedX = Float(roundedX + round(x))
                



                let xPos = Float(x) * resolutionMultiple
                let zPos = Float(z) * resolutionMultiple
                
                vertexList.append(SCNVector3(xPos, yPos, zPos))
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
        var endOfRow = Int(xLength)
        var startOfRow = 0
        for index in 0...vertexList.count - 1 {
            var canGoEast = true
            var canGoNorth = true
            var canGoSouth = true
            var canGoWest = true
            let north = index - Int(zLength)
            if north < 0 {
                canGoNorth = false
            }
            
            let east = index + 1
            if east >= endOfRow {
                endOfRow += Int(xLength)
                startOfRow += Int(xLength)
                canGoEast = false
            }
            
            let south = index + Int(zLength)
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
            
            if vertex.y <= seaLevel
            {
                colorList.append(SCNVector3(0.026, vertex.y, 0.408))
                
            }
            else if vertex.y > 0.3
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
        source.persistence = 0.356
        // determines how smooth the noise, ie how likely it is to change. Higher values create rougher terrain. Keep values below 1.0

        let noise = GKNoise(source)
        let size = vector2(15.0, 15.0)
        let origin = vector2(5.0, 5.0)
        let sampleCount = vector2(Int32(x), Int32(z))
        

        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
    }

}

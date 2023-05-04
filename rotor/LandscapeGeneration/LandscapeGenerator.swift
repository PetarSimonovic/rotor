//
//  LandscapeGenerator.swift
//  rotor
//
//  Created by Petar Simonovic on 18/04/2023.
//

import Foundation
import SceneKit
import GameKit


//struct LandscapeGenerator {
//    
//    
//    var xLength = 100
//    var zLength = 100
//    
//    func generate() -> SCNNode {
//        let map: GKNoiseMap = makeNoiseMap(x: xLength, z: zLength)
//        let vertexList: [SCNVector3] = createVertices(map)
//        
//        let colorList: [SCNVector3] = calculateColors(vertexList)
//        let vertexSpheres: [SCNVector3] = mapToSphere(vertexList: vertexList)
//
//
//        let colors = SCNGeometrySource(colors: colorList)
//        
//        // Sphere experiments
//        
//        
//        
//                
//        // Subdivide the icosahedron faces recursively to create an icosphere
//        let subdivisions = 4
//
//        for _ in 0..<subdivisions {
//            var newVertices: [SCNVector3] = []
//            var newIndices: [Int32] = []
//            
//            for i in stride(from: 0, to: indices.count, by: 3) {
//                let v1: SCNVector3 = vertices[Int(indices[i])]
//                let v2: SCNVector3 = vertices[Int(indices[i+1])]
//                let v3: SCNVector3 = vertices[Int(indices[i+2])]
//                
//                let newVertex1 = createMidPointVertex(v1: v1, v2: v2)
//                let newVertex2 = createMidPointVertex(v1: v1, v2: v3)
//                let newVertex3 = createMidPointVertex(v1: v2, v2: v3)
//                newVertices.append(newVertex1)
//                newVertices.append(newVertex2)
//                newVertices.append(newVertex3)
//                newIndices.append(Int32(newVertices.count))
//                newIndices.append(Int32(newIndices.count + 1 ))
//                newIndices.append(Int32(newIndices.count + 2 ))
//                
//            }
//        }
//        //WINDING ORDER COMPUTERFILE meshes FACE CULLING
//        
//        // let colors = SCNGeometrySource(colors: colorList)
//        
//        
//        
//      //  let elements = SCNGeometryElement(
////            indices: indices,
////            primitiveType: .triangles
//            
//        )
//  
//     //   let landscapeVertices = SCNGeometrySource(vertices: vertices)
//    
//
//        
////        let landscapeGeometry: SCNGeometry = SCNGeometry(
////            sources: [landscapeVertices],
////            elements: [elements] // COLOURS HERE!!!
////        )
////
//    
//        
//        
//
//        let landscapeNode: SCNNode = SCNNode(
//            geometry: landscapeGeometry
//        )
//            
//        let landscapePhysicsShape = SCNPhysicsShape(geometry: landscapeGeometry, options: nil)
//        let landscapePhysicsBody = SCNPhysicsBody(type: .static, shape: landscapePhysicsShape)
//        
//        landscapeNode.physicsBody = landscapePhysicsBody
//        
//        return landscapeNode
//        
//        
//    }
//    
//    func distortVertices(map: GKNoiseMap, vertices: [SCNVector3]) -> [SCNVector3]{
//        var distortedVertices: [SCNVector3] = []
//        var i: Int32 = 1;
//        for vertex in vertices {
//            var xPos = vertex.x * (map.value(at: [i, i]))
//            var yPos = vertex.y * (map.value(at: [i, i]))
//
//            var zPos = vertex.z * (map.value(at: [i, i]))
//            
//            var newVertex: SCNVector3 = SCNVector3(x: xPos, y: yPos, z: zPos)
//            distortedVertices.append(newVertex)
//            i += 1
//        }
//        
//        return distortedVertices
//        
//    }
//
//    func createVertices(_ map: GKNoiseMap) ->  [SCNVector3] {
//        
//        var vertexList: [SCNVector3] = []
//        for x in 1 ... xLength {
//            for z in 1 ... zLength {
//                var yPos = map.value(at: [Int32(x), Int32(z)])
//                if (yPos >= -0.3 && yPos <= 0.3) {
//                    yPos = yPos/Float.random(in: 2 ... 4)
//                } else if (yPos >= 0.3 && yPos <= 0.6) {
//                    yPos = yPos/Float.random(in: 1 ... 2)
//                } else if yPos <= -0.9 {
//                    yPos = -0.9
//                }
//                else if yPos > 0.7 {
//                    yPos = yPos * Float.random(in: 2 ... 3.7)
//                    
//                }
//                let xPos = Float(x) + Float.random(in: -0.7 ... 0.7)
//                let zPos = Float(z) + Float.random(in: -0.7 ... 0.7)
//                
//                vertexList.append(SCNVector3(xPos, yPos, zPos))
//            }
//        }
//        
//        return vertexList
//    }
//    
//    
//    func mapToSphere(vertexList: [SCNVector3]) -> [SCNVector3] {
//        
//        // To map grid coordinates onto a sphere using the equirectangular projection, you can follow these steps:
//        
//
////        Choose a radius for your sphere, which will determine the size of your final mapping.
//        let radius:Float = 40.00
//        var sphereVertices: [SCNVector3] = []
//        let longitudeMultiplier: Float = 360.00/Float(xLength)
//        let latitudeMultiplier: Float = (180.00/Float(zLength) - 90)
//        for coordinates in vertexList {
//            //  Convert the X-coordinate of each grid point to a longitude value by multiplying it by 360/W.
//            
//            let longitude = coordinates.x * longitudeMultiplier
//            
//            //  Convert the Z-coordinate of each grid point to a latitude value by multiplying it by 180/H and subtracting 90.
//            
//            let latitude = coordinates.y * latitudeMultiplier
//            
////  Convert the longitude and latitude values of each grid point to Cartesian coordinates (x,y,z) using the following formulas:
//            
//            let x = cos(longitude) * cos(latitude)
//            
//            let y = sin(longitude) * cos(latitude)
//            
//            let z = sin(latitude)
//            
//            //   Scale the Cartesian coordinates so that they lie on the surface of the sphere with the chosen radius. To do this, divide each coordinate by the square root of the sum of their squares, and then multiply them by the radius.
//            
//            let sqrtValue = Float(sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2)))
//            let sphereXRadius: Float = Float(x * radius)
//            let sphereYRadius: Float = Float(y * radius)
//            let sphereZRadius: Float = Float(z * radius)
//            
//            let sphereX: Float = sphereXRadius / sqrtValue
//            let sphereY: Float = sphereYRadius / sqrtValue
//            let sphereZ: Float = sphereZRadius / sqrtValue
//         
//            sphereVertices.append(SCNVector3(sphereX, sphereY, sphereZ))
//
//            
//        }
//
//        
//        return sphereVertices
//    }
//    
//    func calculateIndices(_ vertexList: [SCNVector3]) -> [Int32] {
//        var indices: [Int32] = []
//        for i in stride(from: 0, to: 600, by: 1) {
//            indices.append(Int32(i + 0))
//            indices.append(Int32(i + 25))
//            indices.append(Int32(i + 1))
//            indices.append(Int32(i + 26))
//            indices.append(Int32(i + 25))
//        }
//        
//        return indices
//
//    }
//    
//    func calculateColors(_ vertexList: [SCNVector3]) -> [SCNVector3] {
//        
//        var colorList: [SCNVector3] = []
//        
//        for vertex in vertexList {
//            
//            if vertex.y <= -0.9
//            {
//                colorList.append(SCNVector3(0.026, vertex.y, 0.408))
//            }
//            else if vertex.y > 1.3
//            {
//                colorList.append(SCNVector3(vertex.y, vertex.y, vertex.y))
//
//            }
//            else {
//                colorList.append(SCNVector3(0.046, vertex.y + Float.random(in: 0.3 ... 0.9), Float.random(in: 0.3 ... 0.39)))
//
//            }
//        }
//        
//        return colorList;
//
//    }
//    
//    }
//    
//    func createMidPointVertex(v1: SCNVector3, v2: SCNVector3) -> SCNVector3 {
//        let newX1 = Float((v1.x + v2.x) / 2.0)
//        let newY1 = Float((v1.y + v2.y) / 2.0)
//        let newZ1 = Float((v1.z + v2.z) / 2.0)
//        return SCNVector3(newX1, newY1, newZ1)
//    }
//    
//   
//            
//    func makeNoiseMap(x: Int, z: Int) -> GKNoiseMap {
//        let source = GKPerlinNoiseSource()
//        source.persistence = 0.7 // determines how smooth the noise, ie how likely it is to change. Higher values create rougher terrain. Keep values below 1.0
//        let noise = GKNoise(source)
//        
//        let size = vector2(12.1, 1.1)
//        let origin = vector2(10.0, 10.0)
//        let sampleCount = vector2(Int32(x), Int32(z))
//
//        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
//    }
//    
//    
//
//}

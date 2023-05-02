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
        
        let colorList: [SCNVector3] = calculateColors(vertexList)
        let vertexSpheres: [SCNVector3] = mapToSphere(vertexList: vertexList)
        let vertices = SCNGeometrySource(vertices: vertexSpheres)

        let indices: [Int32] = calculateIndices(vertexSpheres)

        
        
        
      
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
        let landscapePhysicsBody = SCNPhysicsBody(type: .static, shape: landscapePhysicsShape)
        
        landscapeNode.physicsBody = landscapePhysicsBody
        
        return landscapeNode
        
        
    }

    func createVertices(_ map: GKNoiseMap) ->  [SCNVector3] {
        
        var vertexList: [SCNVector3] = []
        for x in 1 ... xLength {
            for z in 1 ... zLength {
                var yPos = map.value(at: [Int32(x), Int32(z)])
                if (yPos >= -0.3 && yPos <= 0.3) {
                    yPos = yPos/Float.random(in: 2 ... 4)
                } else if (yPos >= 0.3 && yPos <= 0.6) {
                    yPos = yPos/Float.random(in: 1 ... 2)
                } else if yPos <= -0.9 {
                    yPos = -0.9
                }
                else if yPos > 0.7 {
                    yPos = yPos * Float.random(in: 2 ... 3.7)
                    
                }
                let xPos = Float(x) + Float.random(in: -0.7 ... 0.7)
                let zPos = Float(z) + Float.random(in: -0.7 ... 0.7)
                
                vertexList.append(SCNVector3(xPos, yPos, zPos))
            }
        }
        
        return vertexList
    }
    
    
    func mapToSphere(vertexList: [SCNVector3]) -> [SCNVector3] {
        
        // To map grid coordinates onto a sphere using the equirectangular projection, you can follow these steps:
        

//        Choose a radius for your sphere, which will determine the size of your final mapping.
        let radius:Float = 10.00
        var sphereVertices: [SCNVector3] = []
        let longitudeMultiplier: Float = 360.00/Float(xLength)
        let latitudeMultiplier: Float = (180.00/Float(zLength) - 90)
        for coordinates in vertexList {
            //  Convert the X-coordinate of each grid point to a longitude value by multiplying it by 360/W.
            
            let longitude = coordinates.x * longitudeMultiplier
            
            //  Convert the Z-coordinate of each grid point to a latitude value by multiplying it by 180/H and subtracting 90.
            
            let latitude = coordinates.z * latitudeMultiplier
            
//  Convert the longitude and latitude values of each grid point to Cartesian coordinates (x,y,z) using the following formulas:
            
            let x = cos(longitude) * cos(latitude)
            
            let z = sin(longitude) * cos(latitude)
            
            let y = sin(latitude)
            
            //   Scale the Cartesian coordinates so that they lie on the surface of the sphere with the chosen radius. To do this, divide each coordinate by the square root of the sum of their squares, and then multiply them by the radius.
            
            let sqrtValue = Float(sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2)))
            let sphereXRadius: Float = Float(x * radius)
            let sphereYRadius: Float = Float(y * radius)
            let sphereZRadius: Float = Float(z * radius)
            
            let sphereX: Float = sphereXRadius / sqrtValue
            let sphereY: Float = sphereYRadius / sqrtValue
            let sphereZ: Float = sphereZRadius / sqrtValue
         
            sphereVertices.append(SCNVector3(sphereX, sphereY, sphereZ))

            
        }

        
        return sphereVertices
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
            
            if vertex.y <= -0.9
            {
                colorList.append(SCNVector3(0.026, vertex.y, 0.408))
            }
            else if vertex.y > 1.3
            {
                colorList.append(SCNVector3(vertex.y, vertex.y, vertex.y))

            }
            else {
                colorList.append(SCNVector3(0.046, vertex.y + Float.random(in: 0.3 ... 0.9), Float.random(in: 0.3 ... 0.39)))

            }
        }
        
        return colorList;

    }
    
    func makeNoiseMap(x: Int, z: Int) -> GKNoiseMap {
        let source = GKPerlinNoiseSource()
        source.persistence = 0.7 // determines how smooth the noise, ie how likely it is to change. Higher values create rougher terrain. Keep values below 1.0
        source.octaveCount = 12
        let noise = GKNoise(source)
        
        let size = vector2(0.1, 0.1)
        let origin = vector2(10.0, 10.0)
        let sampleCount = vector2(Int32(x), Int32(z))

        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
    }

}

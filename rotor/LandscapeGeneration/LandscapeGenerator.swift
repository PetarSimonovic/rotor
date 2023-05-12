//
//  LandscapeGenerator.swift
//  rotor
//
//  Created by Petar Simonovic on 18/04/2023.
//

import Foundation
import SceneKit
import GameKit


class LandscapeGenerator: ObservableObject {
    
    // Values for asteriods:
    // Persistence
    
    
    let mountainRange: Float = 0.1
    var ico: Ico = Ico()
    
    
    // Default values will create asteroid-like shapes (imperfect spheres with mountains)
    func generate(persistence: Double = 0.0015,  size: Double = 0.07,  origin: Double = 0.18, radius: Float = 70.00, recursions: Int = 3) -> SCNNode {
        
        
        let icosphere: Icosphere = generateIcosphere(recursions: recursions)
        
        
        
        //  let colorList: [SCNVector3] = calculateColors(vertexList)
        
        
        
       
        

        let mapSize: Int32 = Int32(sqrt(Double(icosphere.vertices.count)))
        let map: GKNoiseMap = makeNoiseMap(mapSize: mapSize, persistence: persistence, size: size, origin: origin)

        
        let sphericalNoise = mapNoiseToSphere(map: map, radius: radius)
//        let sphericalNoise = mapToSphereEquiProjection(vertexList: icosphere.vertices, map: map, radius: radius, mapSize: mapSize)
        
        let distortedVertices = distortVertices(sphericalNoise: sphericalNoise, icosphere: icosphere)
        
        let colors = SCNGeometrySource(colors: calculateColors(map: map, mapSize: mapSize))


        
        let landscapeVertices = SCNGeometrySource(vertices: distortedVertices )
        
        let elements = SCNGeometryElement(
            indices: icosphere.indices,
            primitiveType: .triangles
        )
        
        
        
        let landscapeGeometry: SCNGeometry = SCNGeometry(
            sources: [landscapeVertices, colors],
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
    
    func generateIcosphere(recursions: Int = 5) -> Icosphere {
        return ico.generateIcoSphere(recursions: recursions)
    }
    
    func distortVertices(sphericalNoise: [SCNVector3], icosphere: Icosphere) -> [SCNVector3]{
        var distortedVertices: [SCNVector3] = []
        let vertices = icosphere.vertices
        let indices = icosphere.indices
        
        for i in 0...vertices.count - 1 {
            let originalVector = vertices[i]
            let noiseVector = sphericalNoise[i]
            
            
     
            let distortedVector = SCNVector3(
                x: originalVector.x + noiseVector.z,
                y: originalVector.y + noiseVector.z,
                z: originalVector.z + noiseVector.z
                )
            
            distortedVertices.append(distortedVector)
            
        }
        return distortedVertices
        
    }
    
    
    
    
    func calculateColors(map: GKNoiseMap, mapSize: Int32) -> [SCNVector3] {
        
        var colorList: [SCNVector3] = []
        
        for x in 0...mapSize {
            for y in 0...mapSize {
                let noise: Float = map.value(at: [x, y])
                print(noise)
                if noise <= 0
                {
                    print("water")
                    colorList.append(SCNVector3(0.026, abs(noise), 0.408))
                }
                else if abs(noise) >= mountainRange
                {
                    print("Mountain")
                    colorList.append(SCNVector3(abs(noise * 2), abs(noise * 2), abs(noise * 2)))

                }
                else {
                    print("grass")
                    colorList.append(SCNVector3(0.046, abs(noise) + Float.random(in: 0.3 ... 0.9), Float.random(in: 0.3 ... 0.39)))
                    
                }
            }
        }
        
        return colorList;
        
    }
    
    
    
    
    func makeNoiseMap(mapSize: Int32, persistence: Double = 0.01, size: Double = 0.001, origin: Double = 0.01) -> GKNoiseMap {
        let source = GKPerlinNoiseSource()
        source.persistence = persistence // determines how smooth the noise, ie how likely it is to change. Higher values create rougher terrain. Keep values below 1.0
        let noise = GKNoise(source)
        let size = vector2(size, size)
        let origin = vector2(origin, origin)
        let sampleCount = vector2(mapSize, mapSize)
        
        
        let map = GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
        return map
    }
    
    func mapNoiseToSphere(map: GKNoiseMap, radius: Float) -> [SCNVector3] {
        
        let mapWidth: Int = Int(map.sampleCount[0])
        let mapHeight: Int = Int(map.sampleCount[1])
        //    Choose a radius for your sphere, which will determine the size of your final mapping.
        var sphereCoordinates: [SCNVector3] = []
        
        
        for x in 0...mapWidth {
            for y in 0...mapHeight {
                let noise: Float = map.value(at: [Int32(x), Int32(y)])
                let theta = Float(Double(2.0) * Double.pi) * Float(radius) / noise
                let phi = Float(Double.pi) * Float(radius) / noise
                let x_prime = noise * cos(theta) * sin(phi)
                let y_prime = noise * sin(theta) * sin(phi)
                let z_prime = noise * cos(phi)
                let mappedCoordinates = SCNVector3 (Float(x_prime),Float(y_prime), Float(z_prime))
                sphereCoordinates.append(mappedCoordinates)
                
            }
        }
        return sphereCoordinates
    }
    
    func mapToSphereEquiProjection(vertexList: [SCNVector3], map: GKNoiseMap, radius: Float, mapSize: Int32) -> [SCNVector3] {

             // To map grid coordinates onto a sphere using the equirectangular projection, you can follow these steps:
             

     //        Choose a radius for your sphere, which will determine the size of your final mapping.
             var sphereVertices: [SCNVector3] = []
        //  Convert the X-coordinate of each grid point to a longitude value by multiplying it by 360/W.

            let longitudeMultiplier: Float = 360.00/Float(mapSize)
        //  Convert the Z-coordinate of each grid point to a latitude value by multiplying it by 180/H and subtracting 90.

             let latitudeMultiplier: Float = (180.00/Float(mapSize) - 90)
             for coordinates in vertexList {
                 
                 let longitude = coordinates.x * longitudeMultiplier

                 
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

}

//
//  SphereMapper.swift
//  rotor
//
//  Created by Petar Simonovic on 17/03/2024.
//



import Foundation
import SceneKit
import GameKit


class SphereMapper {
    
    // Values for asteriods:
    // Persistence
    
    
    var ico: Ico = Ico()
    
    func mapVertices(map: GKNoiseMap) -> SCNGeometrySource {
        let icosphere = generateIcosphere(recursions: 4)
        
        let sphericalNoise = mapNoiseToSphere(map: map, radius: 1)
//        let sphericalNoise = mapToSphereEquiProjection(vertexList: icosphere.vertices, map: map, radius: radius, mapSize: mapSize)
        
        let distortedVertices = distortVertices(sphericalNoise: sphericalNoise, icosphere: icosphere)
        


        
        let landscapeVertices = SCNGeometrySource(vertices: distortedVertices )
        return landscapeVertices
        
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
    
    
    // Default values will create asteroid-like shapes (imperfect spheres with mountains)
    
    
    func generateIcosphere(recursions: Int = 5) -> Icosphere {
        return ico.generateIcoSphere(recursions: recursions)
    }
    
    func distortVertices(sphericalNoise: [SCNVector3], icosphere: Icosphere) -> [SCNVector3]{
        var distortedVertices: [SCNVector3] = []
        let vertices = icosphere.vertices
        print("Numbner of vertices on Sphere: \(vertices.count)")

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

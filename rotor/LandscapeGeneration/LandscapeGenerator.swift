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
    
        
    func generate() -> SCNNode {
        
        let icosphere: Icosphere = generateIcosphere(recursions: 4)
        
        
        
        //  let colorList: [SCNVector3] = calculateColors(vertexList)
        
        
        
       
        

        let mapSize: Int32 = Int32(sqrt(Double(icosphere.vertices.count)))
        let map: GKNoiseMap = makeNoiseMap(mapSize: mapSize)

        
        let sphericalNoise = mapToSphere(map: map, radius: 0.06)
        let distortedVertices = distortVertices(sphericalNoise: sphericalNoise, icosphere: icosphere)
        
        let colors = SCNGeometrySource(colors: calculateColors(distortedVertices))


        
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
        let ico = Ico()
        return ico.generateIcoSphere(recursions: recursions)
    }
    
    func distortVertices(sphericalNoise: [SCNVector3], icosphere: Icosphere) -> [SCNVector3]{
        var distortedVertices: [SCNVector3] = []
        let vertices = icosphere.vertices
        let indices = icosphere.indices
        
        for i in 0...vertices.count - 1 {
            print("Distortion")
            let originalVector = vertices[i]
            print(originalVector)
            let noiseVector = sphericalNoise[i]
            print(noiseVector)
            print("")
            let disortedVector = SCNVector3(
                x: originalVector.x + noiseVector.x,
                y: originalVector.y + noiseVector.y,
                z: originalVector.z + noiseVector.z
                )
            
            distortedVertices.append(disortedVector)
            
        }
        return distortedVertices
        
    }
    
    
    
    
    func calculateColors(_ vertexList: [SCNVector3]) -> [SCNVector3] {
        
        var colorList: [SCNVector3] = []
        
        for vertex in vertexList {
            
            if abs(vertex.y) <= 0.2
            {
                colorList.append(SCNVector3(0.026, abs(vertex.y), 0.408))
            }
            else if abs(vertex.y) >= 0.5
            {
                colorList.append(SCNVector3(abs(vertex.y), abs(vertex.y), abs(vertex.y)))
                
            }
            else {
                colorList.append(SCNVector3(0.046, abs(vertex.y) + Float.random(in: 0.3 ... 0.9), Float.random(in: 0.3 ... 0.39)))
                
            }
        }
        
        return colorList;
        
    }
    
    
    
    
    func makeNoiseMap(mapSize: Int32) -> GKNoiseMap {
        let source = GKPerlinNoiseSource()
        source.persistence = 0.01 // determines how smooth the noise, ie how likely it is to change. Higher values create rougher terrain. Keep values below 1.0
        let noise = GKNoise(source)
        
        let size = vector2(1.6, 1.6)
        let origin = vector2(10.0, 10.0)
        let sampleCount = vector2(mapSize, mapSize)
        
        
        let map = GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
        return map
    }
    
    func mapToSphere(map: GKNoiseMap, radius: Float) -> [SCNVector3] {
        
        let mapWidth: Int = Int(map.sampleCount[0])
        let mapHeight: Int = Int(map.sampleCount[1])
        //    Choose a radius for your sphere, which will determine the size of your final mapping.
        var sphereCoordinates: [SCNVector3] = []
        
        
        for x in 0...mapWidth {
            for y in 0...mapHeight {
                let noise: Float = map.value(at: [Int32(x), Int32(y)])
                let theta = Float(2.0 * Double.pi) * Float(noise) / radius
                let phi = Float(Double.pi) * Float(noise) / radius
                let x_prime = radius * cos(theta) * sin(phi)
                let z_prime = radius * sin(theta) * sin(phi)
                let y_prime = radius * cos(phi)
                let mappedCoordinates = SCNVector3 (Float(x_prime),Float(y_prime), Float(z_prime))
                sphereCoordinates.append(mappedCoordinates)
                
            }
        }
        return sphereCoordinates
    }
}

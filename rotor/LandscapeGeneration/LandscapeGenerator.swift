
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
    
    var landscapeData: LandscapeData
    
    var xLength: Float = 1000
    var zLength: Float = 1000
    
    // resMultiplier is used to calculate resolution when landscape is drawn
    var resolutionMultiplier: Float = 25
    
    var treeLine: Float = 0.5
    var seaLevel: Float = 0.001
    var lowLands: Float = 0.01
    var terracing: Bool = false
    var rockiness: Double = 0.345
    
    
    mutating func generate() -> SCNNode {
        setLandscapeData()
        let map: GKNoiseMap = makeNoiseMap(x: Int(landscapeData.size), z: Int(landscapeData.size))
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
        let landscapePhysicsBody = SCNPhysicsBody(type: .static, shape: landscapePhysicsShape)
        
        landscapeNode.physicsBody = landscapePhysicsBody
        
        print("Done", landscapeNode)
        landscapeNode.scale = SCNVector3(1000, 1000, 1000)
        return landscapeNode
        
        
    }
    
    mutating func setLandscapeData() -> Void {
        xLength = landscapeData.size
        zLength = landscapeData.size
        treeLine = landscapeData.treeLine
        seaLevel = landscapeData.seaLevel
        terracing = landscapeData.terracing
        rockiness = landscapeData.rockiness
    }

    func createVertices(_ map: GKNoiseMap) ->  [SCNVector3] {
     
        
        let numVertices: Float = xLength * resolutionMultiplier;
        let resolutionMultiple: Float = xLength/numVertices;
        
        var vertexList: [SCNVector3] = []
    
        for x in 1 ... Int(xLength) {
            for z in 1 ... Int(zLength) {
                var yPos = map.value(at: [Int32(x), Int32(z)])
                
              
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
//                if (yPos > seaLevel && yPos < lowLands) {
//                    yPos = yPos * 0.7               }
////
//
//                if yPos < -0.95 {
//                    yPos = -0.7
//                }
                
           
//                    if cliffCount > cliffLength {
//                        print("Cliff reset")
//                        cliff = false
//                        cliffCount = 0
//                        cliffLength = 0
//                    }
//                }
                
            //    if yPos < treeLine
                
                //Cliff
                
        
                
                // Rivers shaping
                if (!terracing) {
                    let W: Float = 0.002; // width of terracing bands
                    let k = floor(yPos / W);
                    let f = (yPos - k * W) / W;
                    let s = min(1.2 * f, 2.0);
                    //   let shapedYPos = sin((k+s) * W)
                    let shapedYPos = (k+s) * W
                    //
                    yPos = yPos * shapedYPos
                    //
                    if  yPos > treeLine + 0.2 {
                        yPos = yPos + Float.random(in: 0.006...0.03)
                    }
                    
                    
                    //  Jagged peaks
                    if yPos > treeLine  {
                        yPos = yPos * 1.03
                    }
                    // X shaping
                    
                    
                    //let amplifiedX = Float(roundedX + round(x))
                }



                let xPos = Float(x) * resolutionMultiple
                let zPos = Float(z) * resolutionMultiple
                
                vertexList.append(SCNVector3(xPos, yPos, zPos))
            }
        }
     

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
        return indices

    }
    
    func calculateColors(_ vertexList: [SCNVector3]) -> [SCNVector3] {
        
        var colorList: [SCNVector3] = []
        
        for vertex in vertexList {
            
            if vertex.y < seaLevel
            {
                colorList.append(SCNVector3(0.026, 0.203, 0.608))
                
            }
            else if vertex.y > treeLine
            {
                colorList.append(SCNVector3(vertex.y, vertex.y, vertex.y))

            }
            else {
                colorList.append(SCNVector3(0.086, vertex.y + 0.3, 0.308))

            }
        }
        
        return colorList;

    }
    
    func makeNoiseMap(x: Int, z: Int) -> GKNoiseMap {
        let seed: Int32 = Int32.random(in: 0...111111)
        let source = GKPerlinNoiseSource()
        source.lacunarity  = 2.08
//source.octaveCount = 12
        // determines how smooth the noise, ie how likely it is to change. Higher values create rougher terrain. Keep values below 1.0
        
        source.persistence = rockiness // 0.345

        source.seed = seed
        let noise = GKNoise(source)
        
        // resolution multipliers allow the resoltion to be changed programatically while
        // still generating landscapes that look like the initial values (sampleCount: 500, 500, size: 15.00, origin: 7.00, resoultion: 25.00)
        let sizeResolutionCorrection: Float =  ((resolutionMultiplier/xLength) * 10.00) * 2.0
        let sizeResolutionBase: Float = 375.00
        let sizeValue: Float = (sizeResolutionBase / resolutionMultiplier) * (xLength/500)
        
        let size: SIMD2<Double> = SIMD2<Double>(vector2(sizeValue, sizeValue))
        let originResolutionBase: Float = 175
        let originValue: Float = (originResolutionBase / resolutionMultiplier) * (xLength/500)
        
        let origin: SIMD2<Double> = SIMD2<Double>(vector2(originValue, originValue))
        let sampleCount = vector2(Int32(x), Int32(z))
        
        if (terracing) {
            noise.remapValues(toTerracesWithPeaks: createTerraceSteps(), terracesInverted: false)
        }

        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
    }
    
    func createTerraceSteps() -> [NSNumber] {
        var numbers = [NSNumber]()
        var value: Float = 0.0
        for _ in 0..<12 {
            numbers.append(NSNumber(value: value))
            value += 0.1
        }
        return numbers
    }
}

//
//  Extensions.swift
//  rotor
//
//  Created by Petar Simonovic on 01/05/2023.
//

import Foundation
import SceneKit

extension SCNNode {
    
    func placeInFrontOfNode(inFrontOf node: SCNNode, atDistance distance: Float) -> SCNVector3 {
        let localPosition = SCNVector3(x: 0, y: 0, z: Float(CGFloat(-distance)))
        let scenePosition = node.convertPosition(localPosition, to: nil)
             // to: nil is automatically scene space
        return scenePosition
    }
}

extension  SCNGeometry{
    
    func getVertices(multiple: Float) -> [SCNVector3]? {
        
        let sources = self.sources(for: .vertex)
        
        guard let source  = sources.first else {return nil}
        
        let stride = source.dataStride / source.bytesPerComponent
        let offset = source.dataOffset / source.bytesPerComponent
        let vectorCount = source.vectorCount
        return source.data.withUnsafeBytes { dataBytes in
            let buffer: UnsafePointer<Float> = dataBytes.baseAddress!.assumingMemoryBound(to: Float.self)
            var result = Array<SCNVector3>()
            for i in 0...vectorCount - 1 {
                let start = i * stride + offset
                let x = buffer[start] * multiple
                let y = buffer[start + 1] * multiple
                let z = buffer[start + 2] * multiple
                
                
                result.append(SCNVector3(x, y, z))
            }
            return result
        }
        
    }
}

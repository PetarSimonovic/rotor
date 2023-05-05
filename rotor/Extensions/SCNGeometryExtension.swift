//
//  SCNGeometryExtension.swift
//  rotor
//
//  Created by Petar Simonovic on 05/05/2023.
//

import Foundation
import SceneKit

public extension SCNGeometrySource {
    /// Initializes a `SCNGeometrySource` with a list of colors as
    /// `SCNVector3`s`.
    convenience init(colors: [SCNVector3]) {
        let colorData = Data(bytes: colors, count: MemoryLayout<SCNVector3>.size * colors.count)

        self.init(
            data: colorData,
            semantic: .color,
            vectorCount: colors.count,
            usesFloatComponents: true,
            componentsPerVector: 3,
            bytesPerComponent: MemoryLayout<Float>.size,
            dataOffset: 0,
            dataStride: MemoryLayout<SCNVector3>.size
        )
    }
        
}


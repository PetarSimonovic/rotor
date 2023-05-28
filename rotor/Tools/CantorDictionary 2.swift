//
//  CantorDictionary.swift
//  rotor
//
//  Created by Petar Simonovic on 08/05/2023.
//

import Foundation

class CantorDictionary {
    
    var dictionary: [Int32 : Int32]
    
    init() {
        self.dictionary = [:]
    }
    
    func getKey(a: Int32, b: Int32) -> Int32 {
        // Cantor's pairing function  takes two non-negative integers and returns a unique integer
        // Use this to build a dictionary of key/indices pairs
        
        let min = min(a, b)
        let max = max(a, b)
        
        let key = ((min + max) * (min + max + 1) / 2) + max
        return key
    }

    
    func set(key: Int32, value: Int32) {
        self.dictionary[key] = value
    }
    
    func getValueFor(key: Int32) -> Int32? {
        return self.dictionary[key]
        
    }
}

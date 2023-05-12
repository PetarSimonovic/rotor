//
//  CantorDictionary.swift
//  rotor
//
//  Created by Petar Simonovic on 08/05/2023.
//

import Foundation

// Cantor's pairing function takes two non-negative integers and returns a unique integer
// This can be used, for example, to build a dictionary of key/indices pairs (eg for generation of icospheres)

class CantorDictionary {
    
    var dictionary: [Int32 : Int32]
    
    init() {
        self.dictionary = [:]
    }
    
    func getKey(a: Int32, b: Int32) -> Int32 {
        
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

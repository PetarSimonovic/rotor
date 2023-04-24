//
//  Extensions.swift
//  rotor Watch App
//
//  Created by Petar Simonovic on 22/04/2023.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func calculateRateOfChange(newValue: Double) -> Double {
        return (self - newValue) / self * 100
        
    }
}




//
//  MotionDetector.swift
//  rotor Watch App
//
//  Created by Petar Simonovic on 06/02/2023.
//

import Foundation
import CoreMotion

class MotionDetector : ObservableObject {
    
    let watchConnecter = WatchConnector()
    
    

    
    var started = false
    
    private var motionManager = CMMotionManager();
    
    func getData()
    {
            if let accelerometerData = motionManager.accelerometerData {
                let gravityFloat = accelerometerData.acceleration.x * 50
                watchConnecter.send("\(String(gravityFloat))")
        }
    }
    
    func start() {
        
        motionManager.startAccelerometerUpdates()
        }
    
   
}

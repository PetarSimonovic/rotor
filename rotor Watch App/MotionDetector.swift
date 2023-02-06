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
    
    var gravity = 0.0
    

    
    var started = false
    
    private var motionManager = CMMotionManager();
    
    func getData() -> Double    {
            if let accelerometerData = motionManager.accelerometerData {
               return accelerometerData.acceleration.x * 50
            } else {
                return 0.0
            }
    }
    
    func start() {
        
        motionManager.accelerometerUpdateInterval = 0.2
        let queue = OperationQueue()
        motionManager.startAccelerometerUpdates(to: queue, withHandler: {accelerometerData, error in
            guard let accelerometerData = accelerometerData else {
                return
            }
            let accelerationY = accelerometerData.acceleration.gr
            self.watchConnecter.send("\(String(accelerationY))")
                
            
            })

    }
    

    
   
}

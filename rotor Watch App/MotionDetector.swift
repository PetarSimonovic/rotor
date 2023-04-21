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
    
    var jumps: Int = 0
    

    
    var started = false
    
    private var motionManager = CMMotionManager();
    
    func getData() -> Double    {
            if let accelerometerData = motionManager.accelerometerData {
               return accelerometerData.acceleration.x
            } else {
                return 0
            }
    }
    
    
    
    func start() {
        
        motionManager.accelerometerUpdateInterval = 0.2
        let queue = OperationQueue()
        motionManager.startAccelerometerUpdates(to: queue, withHandler: {accelerometerData, error in
            guard let accelerometerData = accelerometerData else {
                return
            }
            let accelerationY = accelerometerData.acceleration.y
         //   self.watchConnecter.send("\(String(accelerationY))")
            self.watchConnecter.send("\(String(self.jumps))")

            
            })

    }
    
    
    func incrementJumps() {
        jumps += 1
        self.watchConnecter.send("\(String(self.jumps))")

    }
    
    
    func resetJumps() {
        jumps  = 0
        self.watchConnecter.send("\(String(self.jumps))")

    }
    
    
   
}

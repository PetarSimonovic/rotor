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
    
    var jumpMotionData: Double = 0.0
    var rateOfChange: Double = 0.0
    var jump: String = ""

    
    var motionManager: CMMotionManager!
    
  
    
    
    
    func startAccelerometer() {
        motionManager = CMMotionManager()

        motionManager.accelerometerUpdateInterval = 0.2
        let queue = OperationQueue()
        motionManager.startAccelerometerUpdates(to: queue, withHandler: {data, error in
            if !self.motionManager.isAccelerometerAvailable {
                return
            }

            guard let motionData = data else {
                return
            }
            
            self.rateOfChange = self.jumpMotionData.calculateRateOfChange(newValue: motionData.acceleration.y)
            if self.rateOfChange > 150.00 {
                self.incrementJumps()
                self.jump = "jump"
                
            } else {
                self.jump = ""
            }
            self.jumpMotionData = motionData.acceleration.y
            })

    }
    
    
    func incrementJumps() {
        jumps += 1
        print("JUMP!")
        self.watchConnecter.send("\(String(self.jumps))")

    }
    
    
    func resetJumps() {
        jumps  = 0
        self.watchConnecter.send("\(String(self.jumps))")
    }
    
    
    func stopAccelerometer() {
        motionManager?.stopAccelerometerUpdates();
    }
    
   
}

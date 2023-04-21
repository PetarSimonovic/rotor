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
    
    func getData() -> String   {
        if let deviceMotionData = motionManager.deviceMotion {
                let x = String(deviceMotionData.gravity.x)
                let y = String(deviceMotionData.gravity.y)
                let z = String(deviceMotionData.gravity.z)
                return x + y + z
            } else {
                return "static"            }
    }
    
    
    
    func start() {
        
        motionManager.deviceMotionUpdateInterval = 0.2
        let queue = OperationQueue()
        motionManager.startDeviceMotionUpdates(to: queue, withHandler: {deviceMotionData, error in
        
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

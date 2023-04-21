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
    
    @Published var gravityY: Double = 0.0
    
    private var motionManager = CMMotionManager();
    
  
    
    
    
    func start() {
        
        motionManager.deviceMotionUpdateInterval = 0.2
        let queue = OperationQueue()
        motionManager.startDeviceMotionUpdates(to: queue, withHandler: {data, error in
            guard let motionData = data else {
                return
            }
            self.gravityY = Double(round(1000 * motionData.gravity.y) / 1000) //   self.watchConnecter.send("\(String(accelerationY))")
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

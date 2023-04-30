//
//  MotionDetector.swift
//  rotor Watch App
//
//  Created by Petar Simonovic on 06/02/2023.
//

import Foundation
import CoreMotion

@MainActor class MotionDetector : ObservableObject {
    
    let watchConnecter = WatchConnector()
    
    var jumps: Int = 0
    
    
    
    var started = false
    
    var jumpMotionData: Double = 0.0
    var rateOfChange: Double = 0.0
    var forwardAxisTurned: Bool = false
    var backwardAxisTurned: Bool = false
    var turnComplete = true
    let jumpThreshold: Double = 250

    
    var motionManager: CMMotionManager!
    var queue: OperationQueue!
    
  
    
    
    
    func startMotionDetection() {
        motionManager = CMMotionManager()
        queue = OperationQueue()


        startAccelerometer()
        startGyroScope()

    }
    
    func startAccelerometer() {
        motionManager.accelerometerUpdateInterval = 0.1
        print(motionManager.isAccelerometerAvailable)

        motionManager.startAccelerometerUpdates(to: queue, withHandler: {data, error in
            if !self.motionManager.isAccelerometerAvailable {
                return
            }

            guard let motionData = data else {
                return
            }
            
            
            self.rateOfChange = abs(self.jumpMotionData.calculateRateOfChange(newValue: motionData.acceleration.y))

            if self.rateOfChange > self.jumpThreshold {
                self.checkJump()
                
            }
            self.jumpMotionData = motionData.acceleration.y
            })
    }
    
    func startGyroScope() {
        print("starting gyroscope")
        print(motionManager.isDeviceMotionAvailable)
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: queue, withHandler: { data, error in
            
            if !self.motionManager.isDeviceMotionAvailable {
                print("No gyroscope")
                return
            }
            
            guard let motionData = data else {
                print("No motuondata for gyroscope")
                return
            }
            
            
            self.processTurn(gyroPosition: motionData.rotationRate.z.round(to: 2));
            
        })
        
    }
    
    func checkJump() {
        if turnComplete {
            incrementJumps()
        }
        resetTurn()

    }
    
    
    func incrementJumps() {
        print("Valid skip!")
        jumps += 1
        self.watchConnecter.send("\(String(self.jumps))")

    }
    
    
    func resetJumps() {
        jumps  = 0
        self.watchConnecter.send("\(String(self.jumps))")
    }
    
    func resetTurn() {
        forwardAxisTurned = false
        backwardAxisTurned = false
        turnComplete = false
    }
    
    func processTurn(gyroPosition: Double) {
        if gyroPosition > 1 {forwardAxisTurned = true}
        if gyroPosition < -1 {backwardAxisTurned = true}
        if forwardAxisTurned && backwardAxisTurned {
            print("Turn")
            turnComplete = true;
        }
    }
    
    
    func stopMotionUpdates() {
        motionManager?.stopAccelerometerUpdates()
        motionManager?.stopDeviceMotionUpdates()

    }

    
   
}

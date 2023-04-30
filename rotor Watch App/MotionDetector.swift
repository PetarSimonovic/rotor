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

    
    var motionManager: CMMotionManager!
    var queue: OperationQueue!
    
  
    
    
    
    func startMotionDetection() {
        motionManager = CMMotionManager()
        queue = OperationQueue()


        startAccelerometer()
        startGyroScope()

    }
    
    func startAccelerometer() {
        motionManager.accelerometerUpdateInterval = 0.2
        print(motionManager.isAccelerometerAvailable)

        motionManager.startAccelerometerUpdates(to: queue, withHandler: {data, error in
            if !self.motionManager.isAccelerometerAvailable {
                return
            }

            guard let motionData = data else {
                return
            }
            
            self.rateOfChange = self.jumpMotionData.calculateRateOfChange(newValue: motionData.acceleration.y)
            if self.rateOfChange > 200.00 {
                self.checkJump()
                
            }
            self.jumpMotionData = motionData.acceleration.y
            })
    }
    
    func startGyroScope() {
        print("starting gyroscope")
        print(motionManager.isDeviceMotionAvailable)
        motionManager.deviceMotionUpdateInterval = 0.2
        motionManager.startDeviceMotionUpdates(to: queue, withHandler: { data, error in
            
            if !self.motionManager.isDeviceMotionAvailable {
                print("No gyroscope")
                return
            }
            
            guard let motionData = data else {
                print("No motuondata for gyroscope")
                return
            }
            
            self.processTurn(zPosition: motionData.rotationRate.z.round(to: 2));
            
        })
        
    }
    
    func checkJump() {
        if turnComplete {
            print("Valid jump!")
            incrementJumps()
            resetTurn()
        }
    }
    
    
    func incrementJumps() {
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
    
    func processTurn(zPosition: Double) {
        if zPosition > 1 {forwardAxisTurned = true}
        if zPosition < -1 {backwardAxisTurned = true}
        if forwardAxisTurned && backwardAxisTurned {
            print("Turn complete")
            turnComplete = true;
            resetTurn()
        }
    }
    
    
    func stopMotionUpdates() {
        motionManager?.stopAccelerometerUpdates()
        motionManager?.stopDeviceMotionUpdates()

    }

    
   
}

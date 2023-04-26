//
//  ContentView.swift
//  rotor Watch App
//
//  Created by Petar Simonovic on 04/02/2023.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    
    
    var watchConnector = WatchConnector()
    
    @ObservedObject private var motionDetector = MotionDetector()
    @ObservedObject private var watchWorkoutManager = WatchWorkoutManager()
    
    @State private var workoutHasStarted: Bool = false;

    
    func increment() {
        print("Increment!")
        self.motionDetector.incrementJumps()
        
    }
    
    func reset() {
        print("Increment!")
        self.motionDetector.resetJumps()
        
    }
    
     func toggleStartWorkout() {
        if workoutHasStarted {
            workoutHasStarted = false
            watchWorkoutManager.stopWorkoutSession()
            motionDetector.stopAccelerometer()
            
        } else {
            workoutHasStarted = true
            watchWorkoutManager.startWorkoutSession()
            motionDetector.startAccelerometer()

        }

    }
   
  
    var body: some View {
        VStack {
            Text(motionDetector.jump)
            Text("Version 1")
            Button(action: increment) {
                Text("Increment")
            }
            Button(action: reset) {
                Text("Reset")
            }
            
            Button(action: self.toggleStartWorkout) {
                Text(self.workoutHasStarted ? "End" : "Start")
            }

        }
        .padding()
        .onAppear{
            watchWorkoutManager.start()
        }
    }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

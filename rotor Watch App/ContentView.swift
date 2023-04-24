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
    
    @ObservedObject private var workoutManager = WorkoutManager()

    @State private var gravity = "No reading"
    
    func increment() {
        print("Increment!")
        self.motionDetector.incrementJumps()
        gravity = String(motionDetector.jumps)
        
    }
    
    func reset() {
        print("Increment!")
        self.motionDetector.resetJumps()
        gravity = String(motionDetector.jumps)
        
    }
   
  
    var body: some View {
        VStack {
            Text(String(workoutManager.healthText))
            Button(action: increment) {
                Text("Increment")
            }
            Button(action: reset) {
                Text("Reset")
            }

        }
        .padding()
        .onAppear{
            workoutManager.start()
            motionDetector.start()
            
        }
    }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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

    @State private var gravity = "No reading"
    
   
  
    var body: some View {
        VStack {
            Button("Send data") {
                motionDetector.getData()
            }
        }
        .padding()
        .onAppear{
            motionDetector.start()
            
        }
    }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

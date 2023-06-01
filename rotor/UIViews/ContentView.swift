//
//  ContentView.swift
//  rotor
//
//  Created by Petar Simonovic on 04/02/2023.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    
    @ObservedObject private var workoutManager = PhoneWorkoutManager()
    @StateObject private var iosConnector = iOSConnector()


    
    var sceneKitView = SceneKitView()
    
    func checkJumps() {
        print(self.iosConnector.notificationMessage?.text ?? "no message")
    }
    

    var body: some View {
 
        VStack {
            ZStack {
                sceneKitView
           //     Title()
            }
            ZStack {
                Button(action: sceneKitView.applyThrust) {
                    Text("Jump")
                    
                }
                
            }
        }
        .environmentObject(iosConnector)
        .onAppear{workoutManager.start()}
        .onChange(of: self.iosConnector.notificationMessage?.text, perform: {newValue in
            sceneKitView.applyThrust()
        })
    }
        
}



struct Title: View {
    var body: some View {
        Text("r   o   t   o   r")
            .zIndex(2)
            .font(.system(size: 56, design: .default))
            .foregroundColor(.white)
            .frame(height: 300, alignment: .topLeading)

    }
}
struct Counter: View {
    let jumpCount: String
    var body: some View {
        Text(jumpCount)
            .zIndex(2)
            .font(.system(size: 56, design: .default))
            .foregroundColor(.white)
            .frame(height: 300, alignment: .topLeading)

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

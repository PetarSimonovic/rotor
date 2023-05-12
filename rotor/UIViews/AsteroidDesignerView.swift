//
//  AsteroidDesignerView.swift
//  rotor
//
//  Created by Petar Simonovic on 12/05/2023.
//

import SwiftUI
import WatchConnectivity

struct AsteroidDesignerView: View {
    
    @ObservedObject private var workoutManager = PhoneWorkoutManager()
    @StateObject private var iosConnector = iOSConnector()

    @State private var wire = false;

    @State private var recursions: Int = 0
    
    @State private var recursionsSlider: Double = 0.0
    
    @State private var radius: Double = 0.1
    
    @State private var persistence = 0.01
 
    @State private var size: Double = 0.001
    
    @State private var origin: Double = 0.01
    
    var sceneKitView = SceneKitView()
    
    func checkJumps() {
        print(self.iosConnector.notificationMessage?.text ?? "no message")
    }
    
    func generateLandscape(){
        sceneKitView.generateLandscape(persistence: persistence, size: size, origin: origin, wireframe: wire, recursions: recursions, radius: Float(radius))
    }
    
    func toggleWire(){
        wire = !wire
        generateLandscape()
        
    }
    
    func handleRecursionsChange() {
        recursions = Int(recursionsSlider)
        generateLandscape()
    }
    
    var body: some View {
 
        ZStack {
            HStack{
            HStack {
                sceneKitView
            }
            .zIndex(1)
            HStack {
                VStack{
                    
                    ParamSlider(value: $persistence, text: "Persistence", action: generateLandscape, range: 1)
                
                
                    ParamSlider(value: $size, text: "Size", action: generateLandscape, range: 5)
                    
                    ParamSlider(value: $origin, text: "Origin", action: generateLandscape, range: 5)
                    
                    ParamSlider(value: $radius, text: "Radius", action: generateLandscape, range: 100)

                    
                    ParamSlider(value: $recursionsSlider, text: "Recursions", action: handleRecursionsChange, range: 6)

                    Button(action: toggleWire) {
                        Text(wire ? "Solid" : "Wire")
                    }

                }
                
                
            }
            
            .zIndex(2)
        }
        }
        .environmentObject(iosConnector)
        .onAppear{workoutManager.start()}
        .onChange(of: self.iosConnector.notificationMessage?.text, perform: {newValue in
            sceneKitView.applyThrust()
        })
    }
        
}

struct ParamSlider: View {
    
    
    @Binding var value: Double
    let text: String
    let action: () -> Void
    let range: Double
    
    var body: some View {
        VStack {
            Slider(value: $value, in: 0...range, onEditingChanged: { _ in                 action()})
            Text("\(text) \(String(value))")
        }
    }
}



struct AsteroidDesignerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


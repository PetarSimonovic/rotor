//
//  ContentView.swift
//  rotor
//
//  Created by Petar Simonovic on 04/02/2023.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    
    
    
    
    
    @State private var showLandscape = false
    
    @State private var size: Float = 500
    @State private var treeLine: Float = 0.5
    @State private var seaLevel: Float = 5.0



    
    var body: some View {
        
        VStack {
            Button(action: {
                self.showLandscape.toggle()
            }) {
                Text(showLandscape ? "Shape Land" : "Create Land")
            }
            if showLandscape {
                LandscapeView(landscapeData: validateData())
            } else {
                VStack {
                    Text("Size: \(Int(size))")
                Slider(value: $size, in: 100...1000, step: 1)
                }
                VStack {
                    Text("Treeline: \(Double(treeLine))")
                    Slider(value: $treeLine, in: 0...5, step: 0.1)
                }
                VStack {
                    Text("Sea Level: \(Double(seaLevel))")
                    Slider(value: $seaLevel, in: 0...30, step: 0.1)
                }

            }
        }
        
    
    }
    
    func validateData() -> LandscapeData {
        return LandscapeData(size: size, treeLine: treeLine, seaLevel: seaLevel/1000)
    }

        
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

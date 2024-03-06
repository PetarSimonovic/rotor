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

    
    var body: some View {
        
        VStack {
            Button(action: {
                self.showLandscape.toggle()
            }) {
                Text("Toggle")
            }
            if showLandscape {
                LandscapeView(size: size)
            } else {
                VStack {
                    Text("Size: \(Int(size))")
                Slider(value: $size, in: 100...1000, step: 1)
                }
            }
        }

        
        
        
        
    }
    
    
        
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

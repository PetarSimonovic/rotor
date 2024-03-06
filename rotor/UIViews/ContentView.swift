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
    
    var body: some View {
        
        VStack {
            Button(action: {
                self.showLandscape.toggle()
            }) {
                Text("Toggle")
            }
            if showLandscape {
                SceneKitView()
            } else {
                Text("Settings here")
            }
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
}

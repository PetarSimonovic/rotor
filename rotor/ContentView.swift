//
//  ContentView.swift
//  rotor
//
//  Created by Petar Simonovic on 04/02/2023.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    
    
    @ObservedObject private var iosConnector = iOSConnector()
    var sceneKitView = SceneKitView()
    
    var body: some View {
        ZStack {
            sceneKitView
                .zIndex(1)
            Text("r   o   t   o   r")
                .zIndex(2)
                .font(.system(size: 56, design: .default))
                .foregroundColor(.white)
                .frame(height: 300, alignment: .topLeading)
            Spacer()

            Spacer()
            Spacer()

        }
        

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

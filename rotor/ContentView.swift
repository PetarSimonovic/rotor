//
//  ContentView.swift
//  rotor
//
//  Created by Petar Simonovic on 04/02/2023.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    
    
    @StateObject private var iosConnector = iOSConnector()
    @State private var jumpCount: Int = 0;
    var sceneKitView = SceneKitView()
    
    var body: some View {
        ZStack {
            sceneKitView
                .zIndex(1)
                Counter(jumpCount: self.iosConnector.notificationMessage?.text ?? "r  o  t  o  r")
        }
        .environmentObject(iosConnector)
        

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

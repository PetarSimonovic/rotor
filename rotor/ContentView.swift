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
        sceneKitView
//        VStack {
//            Text(self.iosConnector.notificationMessage?.text ?? "No data")
//        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

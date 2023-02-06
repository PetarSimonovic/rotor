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
    
    
    var body: some View {
        VStack {
            Text(self.iosConnector.notificationMessage?.text ?? "0")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

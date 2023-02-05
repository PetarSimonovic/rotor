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
            Button("Click to send", action: {
                iosConnector.send("Hello World!\n\(Date().ISO8601Format())")
            })
        }
        .padding()
        .alert(item: $iosConnector.notificationMessage) { message in
            Alert(title: Text(message.text),
                  dismissButton: .default(Text("Dismiss")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

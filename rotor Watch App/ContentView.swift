//
//  ContentView.swift
//  rotor Watch App
//
//  Created by Petar Simonovic on 04/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    var watchConnector = WatchConnector()
    var body: some View {
        VStack {
            Button("Click to send!", action: {
              watchConnector.send("Hello World!\n\(Date().ISO8601Format())")
            })
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  rotorApp.swift
//  rotor
//
//  Created by Petar Simonovic on 04/02/2023.
//

import SwiftUI

@main
struct rotorApp: App {
    
    private var designer = false
    
    var body: some Scene {
        WindowGroup {
            if designer { AsteroidDesignerView() } else { ContentView() }
        }
    }
}

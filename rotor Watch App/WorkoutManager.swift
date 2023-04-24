//
//  WorkoutManager.swift
//  rotor Watch App
//
//  Created by Petar Simonovic on 24/04/2023.
//

import Foundation
import HealthKit


class WorkoutManager : ObservableObject {
    
    @Published var healthText: String = ""
    
    func start() {
        if HKHealthStore.isHealthDataAvailable() {
            var healthStore = HKHealthStore()
            self.healthText = healthStore.description
        }
        
    }
}

//
//  WorkoutManager.swift
//  rotor Watch App
//
//  Created by Petar Simonovic on 24/04/2023.
//

import Foundation
import HealthKit


class PhoneWorkoutManager : ObservableObject {
    
    @Published var healthText: String = ""
    
    var healthStore: HKHealthStore?
    
    func start() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            self.healthText = healthStore!.description
            requestAuthorisation()

        }
        
    }
    
    func requestAuthorisation() {
        var dataToAccess : Set<HKSampleType> {
            let heartRate = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
            let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
            return [heartRate, activeEnergyBurned]
          }
        
        healthStore!.requestAuthorization(toShare: dataToAccess, read: dataToAccess, completion: { (success, error) in
              if (!success) {
                //  request was not successful, handle user denial
                  print(error)
                  return
              }
        })
    }
}

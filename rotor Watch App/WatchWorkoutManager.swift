//
//  WorkoutManager.swift
//  rotor Watch App
//
//  Created by Petar Simonovic on 25/04/2023.
//

import Foundation
import HealthKit

@MainActor
class WatchWorkoutManager : NSObject, ObservableObject {
    
    @Published var healthText: String = ""
    @Published var heartrate: Double = 0
    @Published var activeCalories: Double = 0
    
    var healthStore: HKHealthStore?
    var builder: HKLiveWorkoutBuilder?
    var session: HKWorkoutSession?
    
    
    
    func start() {
        print("Starting WorkoutManager om Watch")
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            if (self.healthStore!.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!) == .sharingAuthorized) {
                self.healthText = "Permission Granted"
                    } else {
                        self.healthText = "Permission Denied"
                    }
        }
        
    }
    
    func startWorkoutSession()  {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .jumpRope
        configuration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore!, configuration: configuration)
            builder = session!.associatedWorkoutBuilder()
            builder!.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore!, workoutConfiguration: configuration)
        } catch {
            // HKWorkoutSession initializer can throw an exception if the configuration is invalid
            // Handle failure here.
            return
        }
        
        // Assign delegates to monitor the workout session and the workout builder
        // The delegates are in the extensions below
        
        session!.delegate = self
        builder!.delegate = self
        
        // Start
        
        session!.startActivity(with: Date())
        builder!.beginCollection(withStart: Date()) { (success, error) in
            
            guard success else {
                // Handle errors.
                return
            }
            
            // Indicate that the session has started.
        }

    }
    
    func stopWorkoutSession() {
        print("Ending session")
        session!.end()
        builder!.endCollection(withEnd: Date()) { (success, error) in
            
            guard success else {
                // Handle errors.
                return
            }
            
            self.builder!.finishWorkout { (workout, error) in
                
                guard workout != nil else {
                    // Handle errors.
                    return
                }
                
                DispatchQueue.main.async() {
                    // Update the user interface.
                    print(workout!)
                }
            }
        }


    }
 

}

// Delegates
// While the session runs, Apple Watch automatically collects and adds samples and events based on the workout configuration
// Update your app’s user interface whenever the builder receives a new sample or event. To respond to new samples, implement the delegates below

extension WatchWorkoutManager: HKWorkoutSessionDelegate {
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        // code
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        // code
    }
    
    
}

extension WatchWorkoutManager: HKLiveWorkoutBuilderDelegate {
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return // Nothing to do.
            }
            
            // Calculate statistics for the type.
            let statistics = workoutBuilder.statistics(for: quantityType)
            DispatchQueue.main.async() {
                // Update the user interface.
                print(statistics!)
            }
        }
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        let lastEvent = workoutBuilder.workoutEvents.last
            
            DispatchQueue.main.async() {
                // Update the user interface here.
                if lastEvent != nil {
                    print(lastEvent!.description)
                }
            }

    }
    
    
}

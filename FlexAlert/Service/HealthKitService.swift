//
// HealthKitService.swift
//  FlexAlert
//
//  Created by Simon Graeber on 29.04.25.
//

import Foundation
import HealthKit

class HealthKitService {
    /// Controlles HealthKit connection and rights
    static let shared = HealthKitService()
    
    var healthStore = HKHealthStore()
    
    func requestAuthorization() {
        let moveType = HKQuantityType(.appleMoveTime)
        let workoutType = HKObjectType.workoutType()
        
        let healthTypesRead: Set<HKObjectType> = [moveType, workoutType]
        let healthTypesWrite: Set<HKSampleType> = [workoutType]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: healthTypesWrite, read: healthTypesRead)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func checkHealthKitPermissions() {
        let moveType = HKQuantityType(.appleMoveTime)
        let workoutType = HKObjectType.workoutType()
        
        let moveReadStatus = healthStore.authorizationStatus(for: moveType)
        let workoutReadStatus = healthStore.authorizationStatus(for: workoutType)
        
        print("Move Time Read Permission: \(describeStatus(moveReadStatus))")
        print("Workout Read Permission: \(describeStatus(workoutReadStatus))")
        
        // Check write permission for workout
        if let workoutSampleType = workoutType as? HKSampleType {
            let workoutWriteStatus = healthStore.authorizationStatus(for: workoutSampleType)
            print("Workout Write Permission: \(describeStatus(workoutWriteStatus))")
        }
    }
    
    /// Helper method to convert status enum to readable string
    private func describeStatus(_ status: HKAuthorizationStatus) -> String {
        switch status {
        case .notDetermined:
            return "Not Determined (User has not been prompted yet)"
        case .sharingDenied:
            return "Denied"
        case .sharingAuthorized:
            return "Authorized"
        @unknown default:
            return "Unknown"
        }
    }
}

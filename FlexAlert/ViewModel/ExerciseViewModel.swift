//
//  ExerciseViewModel.swift
//  FlexAllert
//
//  Created by Simon Graeber on 12.04.25.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class ExerciseViewModel: ObservableObject {
    /**
     All controlas for ExerciseSheetView and its children :)
     */
    enum ExerciseState {
        case ready, active, paused, completed
    }
    
    var state: ExerciseState = .ready
    var progress: Double = 0.0
    var timeRemaining: Int
    @ObservationIgnored var exercise: Exercise
    // It was not possible to access the environment in a class, so it needs to be explicitly set
    @ObservationIgnored var modelContext: ModelContext?
    
    private var timer: Timer?
    private var startTime: Date?
    private var pausedTimeRemaining: Int?
    private let duration: Double
    
    init(duration: Double, exercise: Exercise, modelContext: ModelContext? = nil) {
        self.duration = duration
        self.timeRemaining = Int(duration)
        self.exercise = exercise
        self.modelContext = modelContext
    }
    
    func start() {
        if state == .ready || state == .completed {
            startTime = Date()
            state = .active
            startTimer()
        } else if state == .paused {
            startTime = Date().addingTimeInterval(-Double(duration - Double(pausedTimeRemaining ?? Int(duration))))
            state = .active
            startTimer()
        }
    }
    
    func pause() {
        if state == .active {
            pausedTimeRemaining = timeRemaining
            state = .paused
            timer?.invalidate()
        }
    }
    
    func stop() {
        state = .ready
        progress = 0.0
        timeRemaining = Int(duration)
        timer?.invalidate()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
    }
    
    private func updateProgress() {
        guard let startTime = startTime, state == .active else {
            return
        }
        
        let elapsedTime = Date().timeIntervalSince(startTime)
        progress = min(elapsedTime / duration, 1.0)
        timeRemaining = max(0, Int(duration - elapsedTime))
        
        // compleated!
        if timeRemaining <= 0 {
            state = .completed
            progress = 1.0
            timer?.invalidate()
            // save a new record
            let record = ExerciseRecord(
                exerciseId: exercise.id,
                date: Date(),
                duration: duration
            )
            guard let modelContext = modelContext else {
                return
            }
            modelContext.insert(record)
            do {
                try modelContext.save()
            } catch {
                return
            }
        }
    }
}

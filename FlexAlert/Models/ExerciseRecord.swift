//
//  ExerciseRecord.swift
//  FlexAllert
//
//  Created by Simon Graeber on 09.04.25.
//

import Foundation
import SwiftData

@Model
final class ExerciseRecord {
    var id: UUID
    var exerciseId: UUID
    var date: Date
    var duration: TimeInterval
    
    init(exerciseId: UUID, date: Date, duration: TimeInterval) {
        self.id = UUID()
        self.exerciseId = exerciseId
        self.date = date
        self.duration = duration
    }
}

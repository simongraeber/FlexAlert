//
//  RecordCard.swift
//  FlexAllert
//
//  Created by Simon Graeber on 09.04.25.
//

import SwiftUI

struct RecordCard: View {
    let record: ExerciseRecord

    var body: some View {
        RecordCardNotRound(record: record)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct RecordCardNotRound: View {
    let record: ExerciseRecord
    let exercise: Exercise?
    
    init(record: ExerciseRecord) {
        self.record = record
        self.exercise = ExerciseStore.shared.getExercise(withId: record.exerciseId)
    }
    
    var body: some View {
        HStack {
            if let imageName = exercise?.imageName, !imageName.isEmpty, UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            } else {
                Image(systemName: "figure.cooldown")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading) {
                Text(exercise?.name ?? "Unknown Exercise")
                    .font(.headline)
                    .padding(.vertical, 8)
                HStack {
                    Text("\(Int(record.duration))s")
                        .font(.subheadline)
                    Spacer()
                    Text(record.date.relativeDisplay())
                        .font(.caption)
                }
            }
            .padding(.trailing)
        }
        .frame(height: 100)
        .background(Color.orange)
    }
}

#Preview {
    RecordCard(
        record: ExerciseRecord(
            exerciseId: ExerciseStore.shared.exercises[0].id,
            date: Date(),
            duration: 120
        )
    )
}

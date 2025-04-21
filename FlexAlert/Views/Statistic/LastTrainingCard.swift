//
//  LastTrainingCard.swift
//  FlexAllert
//
//  Created by Simon Graeber on 12.04.25.
//

import SwiftUI
import SwiftData

struct LastTrainingCard: View {
    @Query(sort: \ExerciseRecord.date, order: .reverse)
    private var records: [ExerciseRecord]
    @State private var navigateToAllRecords = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    navigateToAllRecords = true
                } label: {
                    HStack {
                        Spacer()
                        Text("See all Your Exercises")
                        Image(systemName: "chevron.right")
                    }
                }
                Spacer()
            }
            .padding()
            .buttonStyle(.plain)
            
            // Main contenn
            if let lastRecord = records.first {
                RecordCardNotRound(record: lastRecord)
            } else {
                Text("No Training yet")
                    .font(.headline)
                    .padding(40)
            }
        }
        .background(Color.orange.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .navigationDestination(isPresented: $navigateToAllRecords) {
            PastExerciseListView()
        }
    }
}

#Preview {
    NavigationStack {
        LastTrainingCard()
            .modelContainer(for: ExerciseRecord.self)
    }
}

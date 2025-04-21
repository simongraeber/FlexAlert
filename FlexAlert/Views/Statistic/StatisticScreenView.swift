//
//  StatisticScreenView.swift
//  FlexAllert
//
//  Created by Simon Graeber on 08.04.25.
//

import SwiftUI
import SwiftData

struct StatisticScreenView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            ScrollView {
                StatisticsChart()
                    .padding(.horizontal)
                    .frame(height: 400)
                Divider()
                LastTrainingCard()
                .padding(.horizontal)
                .padding(.top)
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    StatisticScreenView()
        .modelContainer(for: ExerciseRecord.self)
}

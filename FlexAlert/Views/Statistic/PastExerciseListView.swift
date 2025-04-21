//
//  pastExerciseListView.swift
//  FlexAllert
//
//  Created by Simon Graeber on 12.04.25.
//

import SwiftUI
import SwiftData

struct PastExerciseListView: View {
    @Query private var records: [ExerciseRecord]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(monthSections, id: \.id) { section in
                    Section(header: Text(section.month)) {
                        ForEach(section.records) { record in
                            RecordCard(record: record)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Your Paced Exercises")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var monthSections: [MonthSection] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        let grouped = Dictionary(grouping: records) { record -> Date in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: record.date)
            return calendar.date(from: components) ?? record.date
        }
        
        let sortedGroups = grouped.mapValues { groupRecords in
            return groupRecords.sorted { $0.date > $1.date }
        }
        
        return sortedGroups.map {
            MonthSection(month: formatter.string(from: $0.key), records: $0.value, date: $0.key)
        }
        .sorted { $0.date > $1.date }
    }
    
    struct MonthSection: Identifiable {
        let month: String
        let records: [ExerciseRecord]
        let date: Date
        
        var id: String { month }
    }
}


#Preview {
    PastExerciseListView()
        .modelContainer(for: ExerciseRecord.self)
}

//
//  StatisticsCard.swift
//  FlexAllert
//
//  Created by Simon Graeber on 09.04.25.
//

import SwiftUI
import SwiftData
import Charts

struct SmallChartView: View {
    // Help I was not able to Query this for Calendar.current.isDateInToday(record.date)
    @Query private var records: [ExerciseRecord]
    @State var model = StatisticsChartModel()

    let startOfDay = Calendar.current.startOfDay(for: Date())
    let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date()


    var body: some View {
        Chart(records.filter { record in
            Calendar.current.isDateInToday(record.date)
        }) { data in
            BarMark(
                x: .value("Date", data.date, unit: .hour),
                y: .value("Duration", data.duration / 60)
            )
        }
        .chartXScale(domain: startOfDay...endOfDay)
        .chartYAxis(.hidden)
    }
}

struct StatisticsCard: View {
    // just for now
    let goal = 4

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                NavigationLink {
                    StatisticScreenView()
                } label: {
                    Spacer()
                    Group {
                        Text("Statistics")
                        Image(systemName: "chevron.right")
                    }
                }
            }
            .padding()
            .buttonStyle(.plain)
            .background(Color.orange.opacity(0.8))

            // Main content
            Group {
                Text("Today")
                    .font(.title)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                SmallChartView()
                    .frame(height: 100)
                    .padding(20)
            }
            .background(.orange)
            .foregroundStyle(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        StatisticsCard()
            .modelContainer(for: ExerciseRecord.self)
    }
}

//
//  StatisticsChart.swift
//  FlexAllert
//
//  Created by Simon Graeber on 13.04.25.
//

import SwiftUI
import SwiftData
import Charts

struct StatisticsChart: View {
    @Query private var records: [ExerciseRecord]
    @State var model = StatisticsChartModel()
    
    @State private var firstDate: Date?
    @State private var visibleStartDate = Date()
    
    // just for now
    var goal: Double = 2 // 2 minutes
    
    var body: some View {
        VStack {
            GranularityPicker(selection: $model.granularity)
            DateRangeIndicator(startDate: $visibleStartDate, model: $model)
            Chart(records) { data in
                BarMark(
                    x: .value("Date", data.date, unit: model.unit),
                    y: .value("Duration", model.durationInMinAndAsAverage(record: data))
                )
                if model.granularity != .day, goal > 0 {
                    RuleMark(y: .value("Goal", goal))
                        .annotation( alignment: .centerFirstTextBaseline) {
                            Text("Goal")
                        }
                }
            }
            .chartXScale(domain: min(model.lastStartDate, firstDate ?? Date())...model.endDate)
            .chartScrollPosition(x: $visibleStartDate)
            .chartScrollableAxes(.horizontal)
            .chartXAxis {
                AxisMarks(values: .stride(by: model.axisUnit, count: model.interval)) { _ in
                    AxisValueLabel(format: model.axisDateFormat)
                    AxisGridLine()
                }
            }
            .chartXVisibleDomain(length: model.barCount)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: model.granularity)
        }
        .onAppear(
            perform: {
                firstDate = records.min(by: {
                    $0.date < $1.date
                })?.date
            }
        )
    }
}

struct DateRangeIndicator: View {
    @Binding var startDate: Date
    @Binding var model: StatisticsChartModel
    
    private var dateIntervalFormatter: DateIntervalFormatter {
        let formatter = DateIntervalFormatter()
        
        switch model.granularity {
        case .day:
            formatter.timeStyle = .short
            formatter.dateStyle = .medium
            formatter.dateTemplate = "dd MMM hh"
        case .week, .month:
            formatter.timeStyle = .none
            formatter.dateStyle = .medium
        case .sixMonths:
            formatter.dateTemplate = "dd. MMM yyyy"
        case .year:
            formatter.dateTemplate = "MMM yyyy"
        }
        
        return formatter
    }
    
    var body: some View {
        Text(dateIntervalFormatter.string(from: startDate, to: model.visibleEndDate(visibleStartDate: startDate)))
            .font(.subheadline)
    }
}

struct GranularityPicker: View {
    @Binding var selection: StatisticsChartModel.PlotGranularity
    
    var body: some View {
        Picker("Select Option", selection: $selection) {
            ForEach(StatisticsChartModel.PlotGranularity.allCases, id: \.self) { option in
                Text(option.displayName).tag(option)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}

#Preview {
    StatisticsChart()
        .modelContainer(for: ExerciseRecord.self)
        .frame(height: 400)
}

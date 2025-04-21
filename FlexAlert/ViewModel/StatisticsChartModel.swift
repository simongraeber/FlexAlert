//
//  StatisticsChartModel.swift
//  FlexAllert
//
//  Created by Simon Graeber on 13.04.25.
//

import Foundation
import SwiftUI

@Observable
class StatisticsChartModel {
    enum PlotGranularity: CaseIterable {
        case day, week, month, sixMonths, year
        
        var displayName: String {
            switch self {
            case .day: return "D"
            case .week: return "W"
            case .month: return "M"
            case .sixMonths: return "6M"
            case .year: return "Y"
            }
        }
    }
    
    var granularity: PlotGranularity = .day
    private let calendar = Calendar.current
    
    /// Returns the number of seconds that should be displayed at once. To control the time span visible at once.
    var barCount: Int {
        switch granularity {
        case .day: return 24 * 60 * 60  // seconds in a day
        case .week: return 7 * 24 * 60 * 60 // seconds in a week
        case .month: return 31 * 24 * 60 * 60
        case .sixMonths: return 6 * 31 * 24 * 60 * 60
        case .year: return 365 * 24 * 60 * 60
        }
    }
    
    /// the unit to groop the records by
    var unit: Calendar.Component {
        switch granularity {
        case .day: return .hour
        case .week: return .dayOfYear
        case .month: return .dayOfYear
        case .sixMonths: return .weekOfYear
        case .year: return .month
        }
    }
    
    /// X-axis label interval, for example for a day, add a horizontal line every 6 units (hours)
    var interval: Int {
        switch granularity {
        case .day: return 6
        case .week: return 1
        case .month: return 5
        case .sixMonths: return 1
        case .year: return 1
        }
    }
    
    /// granularity of the axis
    var axisUnit: Calendar.Component {
        switch granularity {
        case .day: return .hour
        case .week: return .day
        case .month: return .day
        case .sixMonths: return .month
        case .year: return .month
        }
    }
    
    /// Labels on the axes
    var axisDateFormat: Date.FormatStyle {
        switch granularity {
        case .day:
            return .dateTime
                .hour()
        case .week:
            return .dateTime
                .weekday()
        case .month:
            return .dateTime
                .day()
        case .sixMonths, .year:
            return .dateTime
                .month()
        }
    }
    
    /// Used to show time intervals, calculate the last date that might be visible based on the bar count.
    func visibleEndDate(visibleStartDate: Date) -> Date {
        let plotEndDate = endDate
        return min(
            plotEndDate,
            calendar.date(byAdding: .second, value: barCount, to: visibleStartDate) ?? plotEndDate
        )
    }
    
    /// Convert duration to minutes and calculate the daily average for 6 months (weekly) and for a year (monthly)
    /// SwiftLint did not let me write this in one function, so no split up :(
    func durationInMinAndAsAverage(record: ExerciseRecord) -> Double {
        let sec2min: Double = 60
        
        switch granularity {
        case .day, .week, .month:
            return record.duration / sec2min
        case .sixMonths:
            return calculateSixMonthAverage(record: record, sec2min: sec2min)
        case .year:
            return calculateYearlyAverage(record: record, sec2min: sec2min)
        }
    }

    private func calculateSixMonthAverage(record: ExerciseRecord, sec2min: Double) -> Double {
        let now = Date()
        
        guard calendar.isDate(now, equalTo: record.date, toGranularity: .weekOfYear) else {
            return record.duration / 7 / sec2min
        }
        
        guard let daysSinceWeekStart = calendar.dateComponents([.day], from: record.date, to: now).day else {
            LoggerService.shared.logger.error("Failed to calculate days since week start")
            return 0
        }
        
        return daysSinceWeekStart == 0
            ? record.duration / sec2min
            : record.duration / Double(daysSinceWeekStart) / sec2min
    }

    private func calculateYearlyAverage(record: ExerciseRecord, sec2min: Double) -> Double {
        let now = Date()
        
        guard calendar.isDate(now, equalTo: record.date, toGranularity: .month) else {
            return calculateMonthlyAverage(record: record, sec2min: sec2min)
        }
        
        let components = calendar.dateComponents([.year, .month], from: now)
        guard let startOfMonth = calendar.date(from: components),
              let daysSinceMonthStart = calendar.dateComponents([.day], from: startOfMonth, to: now).day else {
            LoggerService.shared.logger.error("Failed to calculate month data")
            return 0
        }
        
        return daysSinceMonthStart == 0
            ? record.duration / sec2min
            : record.duration / Double(daysSinceMonthStart) / sec2min
    }

    private func calculateMonthlyAverage(record: ExerciseRecord, sec2min: Double) -> Double {
        guard let daysInMonth = calendar.range(of: .day, in: .month, for: record.date)?.count else {
            LoggerService.shared.logger.error("Failed to calculate days in month")
            return 0
        }
        return record.duration / Double(daysInMonth) / sec2min
    }
    //------------------------------------------------------------------------------

    
    /// Ensure the newest bar is not cut and used for displaying the range.
    var endDate: Date {
        let now = Date()
        
        do {
            switch granularity {
            case .day:
                guard let date = calendar.date(byAdding: .hour, value: 1, to: now) else {
                    throw DateError.calculationError
                }
                return date
            case .week:
                guard let date = calendar.date(byAdding: .dayOfYear, value: 1, to: now) else {
                    throw DateError.calculationError
                }
                return date
            case .month:
                guard let date = calendar.date(byAdding: .day, value: 1, to: now) else {
                    throw DateError.calculationError
                }
                return date
            case .sixMonths:
                guard let date = calendar.date(byAdding: .weekOfYear, value: 1, to: now) else {
                    throw DateError.calculationError
                }
                return date
            case .year:
                guard let date = calendar.date(byAdding: .month, value: 1, to: now) else {
                    throw DateError.calculationError
                }
                return date
            }
        } catch {
            LoggerService.shared.logger.error("Could not calculate last start date")
            return now
        }
    }
    
    /// Ensure the chart can fill the full screen even if not enough historical data is present.
    var lastStartDate: Date {
        let now = Date()
        do {
            guard let date = calendar.date(byAdding: .second, value: -1 * barCount, to: now) else {
                throw DateError.calculationError
            }
            return date
        } catch {
            LoggerService.shared.logger.error("Could not calculate last start date")
            return now
        }
    }
    
    enum DateError: Error {
        case calculationError
    }
}

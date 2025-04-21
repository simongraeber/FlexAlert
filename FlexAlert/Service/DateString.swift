//
//  DateString.swift
//  FlexAllert
//
//  Created by Simon Graeber on 16.04.25.
//

import Foundation

extension Date {
    func relativeDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let daysDiff = calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: self),
            to: calendar.startOfDay(for: now)).day ?? 0
        
        // For recent dates (within 2 days)
        if daysDiff <= 2 {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            formatter.dateTimeStyle = .named
            return formatter.localizedString(
                for: calendar.startOfDay(for: self),
                relativeTo: calendar.startOfDay(for: now))
        }

        // For older dates, just day and month
        else {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM" // "15 Apr"
            return formatter.string(from: self)
        }
    }
}

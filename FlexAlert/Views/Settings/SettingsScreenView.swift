//
//  SettingsScreenView.swift
//  FlexAllert
//
//  Created by Simon Graeber on 08.04.25.
//

import SwiftUI

struct SettingsScreenView: View {
    @AppStorage("userDailyGoal") private var goal = 10
    
    var body: some View {
        NavigationStack {
            VStack {
                Stepper("Duration: \(Int(goal))s", value: $goal, in: 1...200)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    SettingsScreenView()
}

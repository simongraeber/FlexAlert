//
//  ContentView.swift
//  FlexAllert
//
//  Created by Simon Graeber on 08.04.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeScreenView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            StatisticScreenView()
                .tabItem {
                    Label("Statistic", systemImage: "chart.bar")
                }
            SettingsScreenView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ExerciseRecord.self)
}

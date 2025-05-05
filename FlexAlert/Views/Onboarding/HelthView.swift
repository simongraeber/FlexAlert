//
//  HelthView.swift
//  FlexAlert
//
//  Created by Simon Graeber on 28.04.25.
//

import SwiftUI

struct HelthView: View {
    var healthKitService = HealthKitService.shared
    var body: some View {
        Text("To track the workouts in your Health app give this app permission to access your Health data.")
        Button {
            healthKitService.requestAuthorization()
        } label: {
            Text("Menage Access")
        }
        Button {
            healthKitService.checkHealthKitPermissions()
        } label: {
            Text("Test Permissions")
        }
    }
}

#Preview {
    HelthView()
}

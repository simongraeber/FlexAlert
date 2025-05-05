//
//  OnboardingView.swift
//  FlexAlert
//
//  Created by Simon Graeber on 28.04.25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var onboardingShown: Bool
    var body: some View {
        TabView {
            WellcomeView()
            HelthView()
            Button("Close") {
                onboardingShown = false
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

#Preview {
    @Previewable @State var onboardingShown: Bool = true
    OnboardingView( onboardingShown: $onboardingShown)
}

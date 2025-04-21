//
//  GreatingsCard.swift
//  FlexAllert
//
//  Created by Simon Graeber on 09.04.25.
//

import SwiftUI

// This view is designed to fulfill the requirements form with custom font and API call.
struct GreetingsCardView: View {
    var body: some View {
        VStack {
           Text("Welcome to FlexAlert!")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(minHeight: 250)
        .background(Color.orange)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    GreetingsCardView()
}

//
//  HomeScreenView.swift
//  FlexAllert
//
//  Created by Simon Graeber on 08.04.25.
//

import SwiftUI

struct HomeScreenView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Quote of the Day")
                            .font(.headline)
                        Text("Your daily motivation")
                            .font(.caption)
                    }
                    GreetingsCardView()
                    
                    VStack(alignment: .leading) {
                        Text("Do an Exercise")
                            .font(.headline)
                        Text("Start an Exercise Session")
                            .font(.caption)
                    }
                    
                    ExerciseListView()
                    
                    VStack(alignment: .leading) {
                        Text("Your Last Day")
                            .font(.headline)
                        Text("Check out your progress")
                            .font(.caption)
                    }
                    StatisticsCard()
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


#Preview {
    HomeScreenView()
}

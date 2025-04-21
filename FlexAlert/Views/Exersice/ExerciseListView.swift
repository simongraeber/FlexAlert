//
//  ExerciseListView.swift
//  FlexAllert
//
//  Created by Simon Graeber on 09.04.25.
//

import SwiftUI

struct ExerciseListView: View {
    let exercises: [Exercise]

    init() {
            let exercisesList = ExerciseStore.shared.exercises
            self.exercises = exercisesList.shuffled()
        }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(exercises) { exercise in
                    ExersiceInfoCardView(exersice: exercise)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ExerciseListView()
}

//
//  ExersiceInfoCardView.swift
//  FlexAllert
//
//  Created by Simon Graeber on 09.04.25.
//

import SwiftUI

struct ExersiceInfoCardView: View {
    var exersice: Exercise
    @State private var showExerciseSheet = false
    
    var body: some View {
        Button {
            showExerciseSheet = true
        } label: {
            VStack {
                Image(exersice.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                VStack {
                    Text(exersice.name)
                        .font(.headline)
                    Text(exersice.shortDescription)
                        .font(.caption)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .padding(.bottom)
            }
            .background(Color.orange)
            .frame(width: 200, height: 300)
            .cornerRadius(10)
        }
        .sheet(isPresented: $showExerciseSheet) {
            ExerciseSheetView(exercise: exersice)
        }
    }
}

#Preview {
    ExersiceInfoCardView(
        exersice: ExerciseStore.shared.exercises[0]
    )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.2))
}

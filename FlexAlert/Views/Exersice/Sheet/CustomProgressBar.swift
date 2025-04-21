//
//  CustomProgressBar.swift
//  FlexAllert
//
//  Created by Simon Graeber on 10.04.25.
//

import SwiftUI

struct ExerciseProgressView: View {
    @Binding var exerciseViewModel: ExerciseViewModel
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                    Rectangle()
                        .fill(.tint)
                        .frame(width: geometry.size.width * CGFloat(exerciseViewModel.progress))
                }
            }
            .frame(height: 10)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(timeString(from: exerciseViewModel.timeRemaining))
                .font(.system(size: 50))
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

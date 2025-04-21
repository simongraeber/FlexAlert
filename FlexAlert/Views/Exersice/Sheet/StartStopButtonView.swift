//
//  StartStopButtonView.swift
//  FlexAllert
//
//  Created by Simon Graeber on 12.04.25.
//

import SwiftUI

struct StartStopButtonView: View {
    @Binding var exerciseViewModel: ExerciseViewModel
    var body: some View {
        Button {
            switch exerciseViewModel.state {
            case .active:
                exerciseViewModel.pause()
                
            case .paused, .ready, .completed:
                exerciseViewModel.start()
            }
        } label: {
            ZStack {
                Circle()
                    .fill(Color.accentColor)
                    .shadow(radius: 4)
                
                Image(systemName: exerciseViewModel.state == .active ? "pause.fill" : "play.fill")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .contentTransition(.symbolEffect(.replace))
                    .padding(exerciseViewModel.state == .active ? 0 : 2)
                    .offset(x: exerciseViewModel.state == .active ? 0 : 2)
            }
            .frame(width: 70, height: 70)
        }
    }
}

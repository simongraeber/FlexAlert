//
//  ExersiceSheetView.swift
//  FlexAllert
//
//  Created by Simon Graeber on 08.04.25.
//

import SwiftUI
import AlertToast

struct ExerciseSheetView: View {
    let exercise: Exercise
    @State private var viewModel: ExerciseViewModel
    @Environment(\.modelContext) private var modelContext
    @State var showToast: Bool = false
    
    init(exercise: Exercise, duration: Double = 60) {
        self.exercise = exercise
        viewModel = ExerciseViewModel(duration: duration, exercise: exercise)
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                ExerciseAnimationView(animationName: exercise.animationName, exerciseViewModel: $viewModel)
            }
            
            HStack {
                Text(exercise.name)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                StartStopButtonView(exerciseViewModel: $viewModel)
                    .padding(.horizontal)
            }
            .padding(.top)
            
            ExerciseProgressView(exerciseViewModel: $viewModel)
            
            Text(exercise.longDescription)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding()
        .onAppear {
            // set the modelContext for the viewModel
            viewModel.modelContext = modelContext
        }
        .onChange(of: viewModel.state) { _, newState in
            if newState == .completed {
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    showToast = false
                }
            }
        }
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .alert, type: .regular, title: "Exercise completed! 🎉")
        }
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    ExerciseSheetView(
        exercise: ExerciseStore.shared.exercises[0]
    )
    .modelContainer(for: ExerciseRecord.self)
}

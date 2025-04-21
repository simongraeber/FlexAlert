//
//  ExerciseStore.swift
//  FlexAllert
//
//  Created by Simon Graeber on 09.04.25.
//

import Foundation

class ExerciseStore {
    /**
     This Singleton Class holds all available exercises, each with a unique and fixed id.
     */
    static let shared = ExerciseStore()

    let exercises: [Exercise] = [
        // Placeholder exercises for now.
        Exercise(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001") ?? UUID(),
            name: "Neck Side Stretch",
            shortDescription: "Release tension in the neck and shoulders.",
            longDescription: "This exercise helps strengthen your lower back muscles and improve flexibility.",
            imageName: "AmimationPlaceHolder",
            animationName: "AnimationNeckSideLeft"
        ),
        Exercise(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002") ?? UUID(),
            name: "Upper Back Stretch",
            shortDescription: "For your upper back",
            longDescription: "This exercise helps strengthen your lower back muscles and improve flexibility.",
            imageName: "AmimationPlaceHolder",
            animationName: "AnimationNeckSideLeft"
        ),
        Exercise(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003") ?? UUID(),
            name: "Wow Stretch",
            shortDescription: "Nice and cool",
            longDescription: "This is a very cool stretch. Just do it!",
            imageName: "AmimationPlaceHolder",
            animationName: "AnimationNeckSideLeft"
        ),
        Exercise(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000004") ?? UUID(),
            name: "The cool stretch",
            shortDescription: "Straighten your arms and legs",
            longDescription: "This is a very cool stretch. You can do it with your arms and legs straight!",
            imageName: "AmimationPlaceHolder",
            animationName: "AnimationNeckSideLeft"
        ),
    ]
    
    func getExercise(withId id: UUID) -> Exercise {
        guard let exercise = exercises.first(where: { $0.id == id }) else {
            return Exercise(
                id: UUID(),
                name: "Not found",
                shortDescription: "This exercise was not found",
                longDescription: "This exercise might not exist anymore",
                imageName: "",
                animationName: "Test_Animation1.usdz"
            )
        }
        return exercise
    }

    private init() {}
}

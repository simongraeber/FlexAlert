//
//  Exercise.swift
//  FlexAllert
//
//  Created by Simon Graeber on 09.04.25.
//

import Foundation

struct Exercise: Identifiable, Hashable {
    /**
    This struct represents a specific exercise, for example, a special type of stretching.
    Hashable and Identifiable for easy use in ForEach and Picker.
    */
    let id: UUID
    let name: String
    let shortDescription: String
    let longDescription: String
    let imageName: String
    let animationName: String
    
    // Implement Hashable conformance
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    
    // Implement Equatable (required by Hashable)
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
            lhs.id == rhs.id
        }
}

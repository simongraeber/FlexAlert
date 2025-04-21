//
//  FlexAlertApp.swift
//  FlexAlert
//
//  Created by Simon Graeber on 08.04.25.
//

import SwiftUI
import SwiftData

@main
struct FlexAlertApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: ExerciseRecord.self)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}

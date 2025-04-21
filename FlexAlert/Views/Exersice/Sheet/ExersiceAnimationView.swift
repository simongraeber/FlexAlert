//
//  ExersiceAnimationView.swift
//  FlexAllert
//
//  Created by Simon Graeber on 09.04.25.
//

import SwiftUI
import RealityKit
import Affe

let gridientColors: [Color] = [
    .exersiceGradiantTop,
    .exersiceGradiantBotten
]


struct ExerciseAnimationView: View {
    var animationName: String
    @Binding var exerciseViewModel: ExerciseViewModel
    @State private var entity: Entity?
    @State private var animations: AnimationLibraryComponent.AnimationCollection?
    
    var body: some View {
        ZStack {
            RealityView { content in
                if let scene = try? await Entity(named: "Scene", in:affeBundle) {
                    content.add(scene)
                    
                    let camera = PerspectiveCamera()
                    camera.position = SIMD3(x: 0, y: 0.85, z: 2.4)
                    content.add(camera)
                    
                    // get the model to see the hirachie open the /Package/Affe in reality cokposer pro
                    if let rootModel = scene.children.first(where: { $0.name == "Root" }) {
                        if let model = rootModel.children.first(where: { $0.name == "Affe_1" }) {
                            entity = model
                            // the firest Animation is the idel animation I have addede directly to the model
                            if let animationComponent = model.components[AnimationLibraryComponent.self] {
                                animations = animationComponent.animations
                                // play default subtree animation
                                if let animation = animationComponent.animations["default subtree animation"] {
                                    model.playAnimation(animation.repeat(), transitionDuration: 1)
                                }
                            }
                        }
                    }
                }
            }
        }
        .background(Gradient(colors: gridientColors))
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onChange(of: exerciseViewModel.state, initial: true) { _, newState in
            reactToState(newState)
        }
    }
    
    private func reactToState(_ state: ExerciseViewModel.ExerciseState) {
        guard let model = entity else {
            LoggerService.shared.logger.warning("entity not found")
            return
        }
        guard let animations else {
            LoggerService.shared.logger.warning("animations not found")
            return
        }
        
        switch state {
        case .active:
            if let animation = animations[animationName] {
                model.playAnimation(animation.repeat(), transitionDuration: 1)
            }

        case .paused:
            if let animation = animations["default subtree animation"] {
                model.playAnimation(animation.repeat(), transitionDuration: 2)
            }

        case .ready, .completed:
            if let animation = animations["default subtree animation"] {
                model.playAnimation(animation.repeat(), transitionDuration: 3)
            }
        }
    }
}

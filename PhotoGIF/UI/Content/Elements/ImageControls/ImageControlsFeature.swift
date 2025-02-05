//
//  ImageControlsFeature.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

enum GenerationState {
    case success
    case failure
    case loading
}

@Reducer
struct ImageControlsFeature: Reducer {
    @Dependency(\.pathOpenPanel) var pathOpenPanel

    @ObservableState
    struct State: Equatable {
        /// The location where the generated file will be saved.
        var outputPath = DirectoryProxy.downloads.path

        /// The name of the output file.
        var outputFilename = "output"

        /// The current state (successful, failed, or loading) of the file generation process.
        var generationState: GenerationState? = nil

        var isFilelistValid: Bool = false

        var displayOutputPath: String {
            self.outputPath.lastFileElement()
        }

        var canGenerate: Bool {
            return self.isFilelistValid && self.generationState != .loading
        }
    }

    enum Action: BindableAction, Equatable {
        case selectPath
        case pathSelected(string: String)
        case binding(BindingAction<State>)
        case generate
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .selectPath:
                return .run { @MainActor send in
                    self.pathOpenPanel { pathString in
                        send(.pathSelected(string: pathString))
                    }
                }
            case let .pathSelected(string: string):
                state.outputPath = string
                return .none
            case .binding:
                return .none
            case .generate:
                return .none
            }
        }
    }
}

//
//  ContentFeature.swift
//  PhotoGIF
//
//  Created by Loyi on 2020/10/18.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import Cocoa
import ComposableArchitecture
import Foundation

@Reducer
struct ContentFeature: Reducer {
    @Dependency(\.gifFactory) var gifFactory
    @Dependency(\.continuousClock) var clock

    @ObservableState
    struct State: Equatable {
        var listState = ImageListFeature.State()
        var controlState = ImageControlsFeature.State()
    }

    enum Action: Equatable {
        case list(action: ImageListFeature.Action)
        case control(action: ImageControlsFeature.Action)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.controlState, action: \.control) {
            ImageControlsFeature()
        }

        Scope(state: \.listState, action: \.list) {
            ImageListFeature()
        }

        Reduce { state, action in
            switch action {
            case .list:
                // Notify the control state of any changes to the file list
                // so that it can verify the current file list’s validity.
                state.controlState.isFilelistValid = state.listState.isValid
                return .none
            case .control(.generate):
                let elements = state.listState.sources.elements
                let outputPath = state.controlState.outputPath
                // Stripping the `.gif` extension to avoid double extensions (`xxx.gif.gif`).
                let outputFilename = state.controlState.outputFilename.replacingOccurrences(of: ".gif", with: "") + ".gif"

                state.controlState.generationState = GenerationState.loading

                return .run { send in
                    let result = self.gifFactory.make(
                        with: elements,
                        path: outputPath,
                        filename: outputFilename
                    )

                    await send(
                        ContentFeature.Action.control(
                            action: .binding(
                                .set(\.generationState, result ? .success : .failure)
                            )
                        )
                    )

                    try await self.clock.sleep(for: .seconds(5))

                    await send(
                        ContentFeature.Action.control(
                            action: .binding(
                                .set(\.generationState, nil)
                            )
                        )
                    )
                }
            case .control:
                return .none
            }
        }
    }
}

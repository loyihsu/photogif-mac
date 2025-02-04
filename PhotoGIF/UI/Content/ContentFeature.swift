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

// TODO: Add tests

@Reducer
struct ContentFeature: Reducer {
    @Dependency(\.gifFactory) var gifFactory
    @Dependency(\.fileOpenPanel) var fileOpenPanel
    @Dependency(\.pathOpenPanel) var pathOpenPanel

    @ObservableState
    struct State: Equatable {
        /// The image sources added by the user to create a GIF.
        var fileList = FileList()

        /// The name of the output file.
        var outputFilename = "output"

        /// The location where the generated file will be saved.
        var outputPath = DirectoryProxy.downloads.path

        /// The current state (successful, failed, or loading) of the file generation process.
        var generationState: GenerationState? = nil

        var displayOutputPath: String {
            self.outputPath.lastFileElement()
        }

        var canGenerate: Bool {
            let hasSources = !self.fileList.sources.isEmpty
            let hasEmptyLengthSource = self.fileList.sources.contains(where: { $0.length.isEmpty == true })
            let hasInvalidLengthSource = self.fileList.sources.contains { !$0.hasValidLength }
            return hasSources && !hasEmptyLengthSource && !hasInvalidLengthSource && self.generationState != .loading
        }

        enum GenerationState {
            case success
            case failure
            case loading
        }
    }

    enum Action: BindableAction {
        case openDocument
        case selectPath
        case edit(item: Source, value: String)
        case remove(item: Source)
        case moveUp(item: Source)
        case moveDown(item: Source)
        case removeAllSources
        case generate
        case binding(BindingAction<State>)
        case filesSelected(urls: [URL])
        case pathSelected(string: String)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .openDocument:
                return .run { @MainActor send in
                    self.fileOpenPanel { fileURL in
                        send(.filesSelected(urls: fileURL))
                    }
                }
            case .selectPath:
                return .run { @MainActor send in
                    self.pathOpenPanel { pathString in
                        send(.pathSelected(string: pathString))
                    }
                }
            case let .edit(item: item, value: value):
                state.fileList.edit(item, with: value)
                return .none
            case let .remove(item: item):
                state.fileList.remove(item)
                return .none
            case let .moveUp(item: item):
                state.fileList.moveUp(item)
                return .none
            case let .moveDown(item: item):
                state.fileList.moveDown(item)
                return .none
            case .removeAllSources:
                state.fileList.removeAllSources()
                return .none
            case .generate:
                let elements = state.fileList.sources.elements
                let outputPath = state.outputPath
                let outputFilename = state.outputFilename.components(separatedBy: ".gif").joined() + ".gif"

                state.generationState = .loading

                return .run { send in
                    let result = self.gifFactory.make(
                        with: elements,
                        path: outputPath,
                        filename: outputFilename
                    )

                    await send(.binding(.set(\.generationState, result ? .success : .failure)))

                    try await Task.sleep(nanoseconds: UInt64(5 * 1_000_000_000))

                    await send(.binding(.set(\.generationState, nil)))
                }
            case let .filesSelected(urls: urls):
                state.fileList.appendSources(urls)
                return .none
            case let .pathSelected(string: string):
                state.outputPath = string
                return .none
            case .binding:
                return .none
            }
        }
    }
}

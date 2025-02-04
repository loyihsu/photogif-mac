//
//  ImageListFeature.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ImageListFeature: Reducer {
    @Dependency(\.fileOpenPanel) var fileOpenPanel

    @ObservableState
    struct State: Equatable {
        /// The image sources added by the user to create a GIF.
        var fileList = FileList()
    }

    enum Action {
        case importDocument
        case edit(item: Source, value: String)
        case remove(item: Source)
        case moveUp(item: Source)
        case moveDown(item: Source)
        case removeAllSources
        case filesSelected(urls: [URL])
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .importDocument:
                return .run { @MainActor send in
                    self.fileOpenPanel { fileURL in
                        send(.filesSelected(urls: fileURL))
                    }
                }
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
            case let .filesSelected(urls: urls):
                state.fileList.appendSources(urls)
                return .none
            case let .edit(item: item, value: value):
                state.fileList.edit(item, with: value)
                return .none
            }
        }
    }
}

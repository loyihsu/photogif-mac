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
    @Dependency(\.nsImage) var nsImage

    @ObservableState
    struct State: Equatable {
        /// The image sources added by the user to create a GIF.
        var sources = IdentifiedArrayOf<Source>()

        /// This serves as a flag to indicate whether the source list is valid.
        var isValid: Bool {
            // The sources list should not be empty.
            let hasSources = !self.sources.isEmpty
            // Every source should have a valid time duration.
            let hasInvalidLengthSource = self.sources.contains { !$0.hasValidLength }
            return hasSources && !hasInvalidLengthSource
        }

        /// Check if the item is the first source.
        func isFirstSource(_ item: Source) -> Bool {
            self.sources.first == item
        }

        /// Check if the item is the last item in the sources.
        func isLastSource(_ item: Source) -> Bool {
            self.sources.last == item
        }
    }

    enum Action: Equatable {
        case importDocument
        case filesSelected(urls: [URL])
        case edit(item: Source, value: String)
        case remove(item: Source)
        case removeAllSources
        case moveUp(item: Source)
        case moveDown(item: Source)
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
            case let .filesSelected(urls: urls):
                for url in urls {
                    guard let image = self.nsImage(url) else { continue }
                    let path = url.absoluteString.replacingOccurrences(of: "file://", with: "")
                    state.sources.append(Source(location: path, length: "1", nsImage: image))
                }
                return .none
            case let .edit(item: item, value: value):
                state.sources[id: item.id]?.length = value
                return .none
            case let .remove(item: item):
                state.sources.remove(item)
                return .none
            case .removeAllSources:
                state.sources.removeAll()
                return .none
            case let .moveUp(item: item):
                guard let idx = state.sources.firstIndex(of: item), idx != 0 else { return .none }

                let left = idx - 1
                let right = idx
                (state.sources[left], state.sources[right]) = (state.sources[right], state.sources[left])
                return .none
            case let .moveDown(item: item):
                guard let idx = state.sources.firstIndex(of: item),
                      idx + 1 < state.sources.count
                else { return .none }

                let left = idx
                let right = idx + 1
                (state.sources[left], state.sources[right]) = (state.sources[right], state.sources[left])
                return .none
            }
        }
    }
}

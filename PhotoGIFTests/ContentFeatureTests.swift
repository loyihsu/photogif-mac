//
//  ContentFeatureTests.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Cocoa
import ComposableArchitecture
@testable import PhotoGIF
import Testing

struct TestGIFFactory: GIFFactory {
    let result: Bool

    init(result: Bool) {
        self.result = result
    }

    func make(
        with sources: [Source],
        path: String,
        filename: String
    ) -> Bool {
        return self.result
    }
}

struct ContentFeatureTests {
    @Test func testGenerateSuccessFlow() async {
        let mockImage = NSImage()
        let receivedFiles = [
            URL(string: "file:///A/B/C/D/E.png")!,
            URL(string: "file:///F/G/H/I/J.png")!,
        ]

        let store = await withDependencies {
            $0.gifFactory = TestGIFFactory(result: true)
            $0.continuousClock = ImmediateClock()
            $0.uuid = .incrementing
            $0.fileOpenPanel = { completion in
                completion(receivedFiles)
            }
            $0.nsImage = { _ in
                mockImage
            }
        } operation: {
            await TestStore(initialState: ContentFeature.State()) {
                ContentFeature()
            }
        }

        await store.send(.list(action: .importDocument))

        await store.receive(.list(action: .filesSelected(urls: receivedFiles))) {
            $0.listState.sources.append(
                Source(
                    id: UUID(0),
                    location: receivedFiles[0].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
            $0.listState.sources.append(
                Source(
                    id: UUID(1),
                    location: receivedFiles[1].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )

            $0.controlState.isFilelistValid = true
            #expect($0.controlState.canGenerate)
        }

        await store.send(.control(action: .generate)) {
            $0.controlState.generationState = .loading
        }

        await store.receive(.control(action: .binding(.set(\.generationState, .success)))) {
            $0.controlState.generationState = .success
        }

        await store.receive(.control(action: .binding(.set(\.generationState, nil)))) {
            $0.controlState.generationState = nil
        }
    }

    @Test func testGenerateFailureFlow() async {
        let mockImage = NSImage()
        let receivedFiles = [
            URL(string: "file:///A/B/C/D/E.png")!,
            URL(string: "file:///F/G/H/I/J.png")!,
        ]

        let store = await withDependencies {
            $0.gifFactory = TestGIFFactory(result: false)
            $0.continuousClock = ImmediateClock()
            $0.uuid = .incrementing
            $0.fileOpenPanel = { completion in
                completion(receivedFiles)
            }
            $0.nsImage = { _ in
                mockImage
            }
        } operation: {
            await TestStore(initialState: ContentFeature.State()) {
                ContentFeature()
            }
        }

        await store.send(.list(action: .importDocument))

        await store.receive(.list(action: .filesSelected(urls: receivedFiles))) {
            $0.listState.sources.append(
                Source(
                    id: UUID(0),
                    location: receivedFiles[0].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
            $0.listState.sources.append(
                Source(
                    id: UUID(1),
                    location: receivedFiles[1].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )

            $0.controlState.isFilelistValid = true
            #expect($0.controlState.canGenerate)
        }

        await store.send(.control(action: .generate)) {
            $0.controlState.generationState = .loading
        }

        await store.receive(.control(action: .binding(.set(\.generationState, .failure)))) {
            $0.controlState.generationState = .failure
        }

        await store.receive(.control(action: .binding(.set(\.generationState, nil)))) {
            $0.controlState.generationState = nil
        }
    }
}

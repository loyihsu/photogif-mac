//
//  ImageControlsFeatureTests.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import ComposableArchitecture
@testable import PhotoGIF
import Testing

struct ImageControlsFeatureTests {
    @Test func testSelectFileFlow() async {
        let store = await withDependencies {
            $0.pathOpenPanel = { completion in
                completion("/A/B/C/D/E/")
            }
        } operation: {
            await TestStore(initialState: ImageControlsFeature.State()) {
                ImageControlsFeature()
            }
        }

        await store.send(\.selectPath)

        await store.receive(.pathSelected(string: "/A/B/C/D/E/")) {
            $0.outputPath = "/A/B/C/D/E/"
            #expect($0.displayOutputPath == "E")
        }
    }

    @Test func testCanGenerate() async {
        let store = await TestStore(initialState: ImageControlsFeature.State()) {
            ImageControlsFeature()
        }

        #expect(await store.state.canGenerate == false)

        await store.send(.binding(.set(\.isFilelistValid, true))) {
            $0.isFilelistValid = true
        }

        #expect(await store.state.canGenerate)

        await store.send(.binding(.set(\.generationState, .loading))) {
            $0.generationState = .loading
        }

        #expect(await store.state.canGenerate == false)
    }
}

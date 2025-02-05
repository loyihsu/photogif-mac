//
//  ImageListFeatureTests.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Cocoa
import ComposableArchitecture
import Foundation
@testable import PhotoGIF
import Testing

struct ImageListFeatureTests {
    @Test func testImportFileFlow() async {
        let mockImage = NSImage()
        let receivedFiles = [
            URL(string: "file:///A/B/C/D/E.png")!,
            URL(string: "file:///F/G/H/I/J.png")!,
        ]

        let store = await withDependencies {
            $0.uuid = .incrementing
            $0.fileOpenPanel = { completion in
                completion(receivedFiles)
            }
            $0.nsImage = { _ in
                mockImage
            }
        } operation: {
            await TestStore(initialState: ImageListFeature.State()) {
                ImageListFeature()
            }
        }

        await store.send(.importDocument)

        await store.receive(.filesSelected(urls: receivedFiles)) {
            $0.sources.append(
                Source(
                    id: UUID(0),
                    location: receivedFiles[0].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
            $0.sources.append(
                Source(
                    id: UUID(1),
                    location: receivedFiles[1].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )

            #expect($0.sources[0].displayName == "E.png")
            #expect($0.sources[1].displayName == "J.png")

            #expect($0.sources[0].hasValidLength)
            #expect($0.sources[1].hasValidLength)
        }
    }

    @Test func testEditFlow() async {
        let mockImage = NSImage()
        let receivedFiles = [
            URL(string: "file:///A/B/C/D/E.png")!,
            URL(string: "file:///F/G/H/I/J.png")!,
            URL(string: "file:///K/L/M/N/O.png")!,
        ]

        let store = await withDependencies {
            $0.uuid = .incrementing
            $0.fileOpenPanel = { completion in
                completion(receivedFiles)
            }
            $0.nsImage = { _ in
                mockImage
            }
        } operation: {
            await TestStore(initialState: ImageListFeature.State()) {
                ImageListFeature()
            }
        }

        await store.send(.importDocument)

        await store.receive(.filesSelected(urls: receivedFiles)) {
            $0.sources.append(
                Source(
                    id: UUID(0),
                    location: receivedFiles[0].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
            $0.sources.append(
                Source(
                    id: UUID(1),
                    location: receivedFiles[1].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
            $0.sources.append(
                Source(
                    id: UUID(2),
                    location: receivedFiles[2].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
        }

        await store.send(.edit(item: Source(
            id: UUID(1),
            location: receivedFiles[1].absoluteString.replacingOccurrences(of: "file://", with: ""),
            length: "1",
            nsImage: mockImage
        ), value: "2")) {
            $0.sources[1].length = "2"
        }
    }

    @Test func testRemoveFlow() async {
        let mockImage = NSImage()
        let receivedFiles = [
            URL(string: "file:///A/B/C/D/E.png")!,
            URL(string: "file:///F/G/H/I/J.png")!,
            URL(string: "file:///K/L/M/N/O.png")!,
        ]

        let store = await withDependencies {
            $0.uuid = .incrementing
            $0.fileOpenPanel = { completion in
                completion(receivedFiles)
            }
            $0.nsImage = { _ in
                mockImage
            }
        } operation: {
            await TestStore(initialState: ImageListFeature.State()) {
                ImageListFeature()
            }
        }

        await store.send(.importDocument)

        await store.receive(.filesSelected(urls: receivedFiles)) {
            $0.sources.append(
                Source(
                    id: UUID(0),
                    location: receivedFiles[0].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
            $0.sources.append(
                Source(
                    id: UUID(1),
                    location: receivedFiles[1].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
            $0.sources.append(
                Source(
                    id: UUID(2),
                    location: receivedFiles[2].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
        }

        await store.send(.remove(item: Source(
            id: UUID(1),
            location: receivedFiles[1].absoluteString.replacingOccurrences(of: "file://", with: ""),
            length: "1",
            nsImage: mockImage
        ))) {
            $0.sources = [
                $0.sources[0],
                $0.sources[2],
            ]
        }
    }

    @Test func testRemoveAllSourcesFlow() async {
        let mockImage = NSImage()
        let receivedFiles = [
            URL(string: "file:///A/B/C/D/E.png")!,
            URL(string: "file:///F/G/H/I/J.png")!,
            URL(string: "file:///K/L/M/N/O.png")!,
        ]

        let store = await withDependencies {
            $0.uuid = .incrementing
            $0.fileOpenPanel = { completion in
                completion(receivedFiles)
            }
            $0.nsImage = { _ in
                mockImage
            }
        } operation: {
            await TestStore(initialState: ImageListFeature.State()) {
                ImageListFeature()
            }
        }

        await store.send(.importDocument)

        await store.receive(.filesSelected(urls: receivedFiles)) {
            $0.sources.append(
                Source(
                    id: UUID(0),
                    location: receivedFiles[0].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
            $0.sources.append(
                Source(
                    id: UUID(1),
                    location: receivedFiles[1].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
            $0.sources.append(
                Source(
                    id: UUID(2),
                    location: receivedFiles[2].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
        }

        await store.send(.removeAllSources) {
            $0.sources = []
        }
    }

    @Test func testMoveUpFlow() async {
        let mockImage = NSImage()
        let receivedFiles = [
            URL(string: "file:///A/B/C/D/E.png")!,
            URL(string: "file:///F/G/H/I/J.png")!,
            URL(string: "file:///K/L/M/N/O.png")!,
        ]

        let store = await withDependencies {
            $0.uuid = .incrementing
            $0.fileOpenPanel = { completion in
                completion(receivedFiles)
            }
            $0.nsImage = { _ in
                mockImage
            }
        } operation: {
            await TestStore(initialState: ImageListFeature.State()) {
                ImageListFeature()
            }
        }

        await store.send(.importDocument)

        await store.receive(.filesSelected(urls: receivedFiles)) {
            $0.sources.append(
                Source(
                    id: UUID(0),
                    location: receivedFiles[0].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
            $0.sources.append(
                Source(
                    id: UUID(1),
                    location: receivedFiles[1].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
            $0.sources.append(
                Source(
                    id: UUID(2),
                    location: receivedFiles[2].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
        }

        await store.send(
            .moveUp(
                item: Source(
                    id: UUID(2),
                    location: receivedFiles[2].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
        ) {
            $0.sources = [
                $0.sources[0],
                $0.sources[2],
                $0.sources[1],
            ]
        }

        await store.send(
            .moveUp(
                item: Source(
                    id: UUID(2),
                    location: receivedFiles[2].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
        ) {
            $0.sources = [
                $0.sources[1],
                $0.sources[0],
                $0.sources[2],
            ]
        }

        await store.send(
            .moveUp(
                item: Source(
                    id: UUID(2),
                    location: receivedFiles[2].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
        )
    }

    @Test func testMoveDownFlow() async {
        let mockImage = NSImage()
        let receivedFiles = [
            URL(string: "file:///A/B/C/D/E.png")!,
            URL(string: "file:///F/G/H/I/J.png")!,
            URL(string: "file:///K/L/M/N/O.png")!,
        ]

        let store = await withDependencies {
            $0.uuid = .incrementing
            $0.fileOpenPanel = { completion in
                completion(receivedFiles)
            }
            $0.nsImage = { _ in
                mockImage
            }
        } operation: {
            await TestStore(initialState: ImageListFeature.State()) {
                ImageListFeature()
            }
        }

        await store.send(.importDocument)

        await store.receive(.filesSelected(urls: receivedFiles)) {
            $0.sources.append(
                Source(
                    id: UUID(0),
                    location: receivedFiles[0].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
            $0.sources.append(
                Source(
                    id: UUID(1),
                    location: receivedFiles[1].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
            $0.sources.append(
                Source(
                    id: UUID(2),
                    location: receivedFiles[2].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
        }

        await store.send(
            .moveDown(
                item: Source(
                    id: UUID(0),
                    location: receivedFiles[0].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
        ) {
            $0.sources = [
                $0.sources[1],
                $0.sources[0],
                $0.sources[2],
            ]
        }

        await store.send(
            .moveDown(
                item: Source(
                    id: UUID(0),
                    location: receivedFiles[0].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
        ) {
            $0.sources = [
                $0.sources[0],
                $0.sources[2],
                $0.sources[1],
            ]
        }

        await store.send(
            .moveDown(
                item: Source(
                    id: UUID(0),
                    location: receivedFiles[0].absoluteString.replacingOccurrences(of: "file://", with: ""),
                    length: "1",
                    nsImage: mockImage
                )
            )
        )
    }
}

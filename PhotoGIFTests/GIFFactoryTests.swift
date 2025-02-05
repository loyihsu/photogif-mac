//
//  GIFFactoryTests.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Testing
import Dependencies
import Cocoa
@testable import PhotoGIF

struct GIFFactoryTests {
    @Test func testGenerateImage() {
        let factory = DefaultGIFFactory()

        let sources = withDependencies {
            $0.uuid = .incrementing
        } operation: {
            [
                Source(
                    location: "",
                    length: "1",
                    nsImage: FileHelper.shared.getBundleNsImage(
                        named: "image1",
                        extension: "jpg"
                    )!
                ),
                Source(
                    location: "",
                    length: "2",
                    nsImage: FileHelper.shared.getBundleNsImage(
                        named: "image2",
                        extension: "jpg"
                    )!
                ),
                Source(
                    location: "",
                    length: "3",
                    nsImage: FileHelper.shared.getBundleNsImage(
                        named: "image3",
                        extension: "jpg"
                    )!
                ),
            ]
        }

        let result = factory.make(
            with: sources,
            path: NSTemporaryDirectory(),
            filename: "/test-output.gif"
        )

        #expect(result == true)

        let generatedData = FileHelper.shared.getTempFile(named: "test-output.gif")!
        let savedData = FileHelper.shared.getBundleFileString(
            named: "generated-file",
            extension: "dat"
        )?.trimmingCharacters(in: .whitespacesAndNewlines)

        #expect(generatedData.base64EncodedString() == savedData)
    }
}

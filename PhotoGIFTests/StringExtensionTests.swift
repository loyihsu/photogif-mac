//
//  StringExtensionTests.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/4.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

@testable import PhotoGIF
import Testing

struct StringExtensionTests {
    @Test func testLastFileElementHelperNormal() async throws {
        let file = "/User/aaa/bbb/ccc"
        #expect(file.lastFileElement() == "ccc")
    }

    @Test func testLastFileElementHelperNormalDirectory() async throws {
        let file = "/User/aaa/bbb/"
        #expect(file.lastFileElement() == "bbb")
    }

    @Test func testLastFileElementHelperNothing() async throws {
        let file = ""
        #expect(file.lastFileElement() == "Image")
    }

    @Test func testLastFileElementHelperInvalidFilePath() async throws {
        let file = "invalidFilePath"
        #expect(file.lastFileElement() == "Image")
    }
}

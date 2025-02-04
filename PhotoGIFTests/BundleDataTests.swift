//
//  BundleDataTests.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/4.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

@testable import PhotoGIF
import Testing

struct TestBundleProxy: BundleProxy {
    func getValue(for key: String) -> String? {
        key
    }
}

struct BundleDataTests {
    @Test func testAppName() {
        #expect(BundleData.appName.string(using: TestBundleProxy()) == "CFBundleName")
    }

    @Test func testVersionString() {
        #expect(BundleData.versionString.string(using: TestBundleProxy()) == "CFBundleShortVersionString")
    }

    @Test func testBuildString() {
        #expect(BundleData.buildString.string(using: TestBundleProxy()) == "CFBundleVersion")
    }

    @Test func testCopyrightString() {
        #expect(BundleData.copyrightString.string(using: TestBundleProxy()) == "NSHumanReadableCopyright")
    }
}

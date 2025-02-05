//
//  ValidatorTests.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/4.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

@testable import PhotoGIF
import Testing

struct ValidatorTests {
    @Test func testMultipleValidatorValid() async throws {
        let validators: [any Validator] = [
            DecimalNumberOnlyValidator(),
            ValidDecimalPointValidator(),
            NonEmptyValidator(),
        ]
        #expect(validators.validate("100.0"))
    }

    @Test func testMultipleValidatorValidNoPoint() async throws {
        let validators: [any Validator] = [
            DecimalNumberOnlyValidator(),
            ValidDecimalPointValidator(),
            NonEmptyValidator(),
        ]
        #expect(validators.validate("100"))
    }

    @Test func testMultipleValidatorInvalidCharacter() async throws {
        let validators: [any Validator] = [
            DecimalNumberOnlyValidator(),
            ValidDecimalPointValidator(),
            NonEmptyValidator(),
        ]
        #expect(validators.validate("100.0a") == false)
    }

    @Test func testMultipleValidatorEmpty() async throws {
        let validators: [any Validator] = [
            DecimalNumberOnlyValidator(),
            ValidDecimalPointValidator(),
            NonEmptyValidator(),
        ]
        #expect(validators.validate(" ") == false)
    }

    @Test func testDecimalNumberOnlyValidatorValid() async throws {
        #expect(DecimalNumberOnlyValidator().validate("100.0"))
    }

    @Test func testDecimalNumberOnlyValidatorValidNoPoint() async throws {
        #expect(DecimalNumberOnlyValidator().validate("100"))
    }

    @Test func testDecimalNumberOnlyValidatorInvalidCharacter() async throws {
        #expect(DecimalNumberOnlyValidator().validate("100.0a") == false)
    }

    @Test func testValidDecimalPointValidatorValid() async throws {
        #expect(ValidDecimalPointValidator().validate("100.0"))
    }

    @Test func testValidDecimalPointValidatorValidNoPoint() async throws {
        #expect(ValidDecimalPointValidator().validate("100"))
    }

    @Test func testValidDecimalPointValidatorPointFirst() async throws {
        #expect(ValidDecimalPointValidator().validate(".100") == false)
    }

    @Test func testValidDecimalPointValidatorPointLast() async throws {
        #expect(ValidDecimalPointValidator().validate("100.") == false)
    }

    @Test func testValidDecimalPointValidatorOnlyPoint() async throws {
        #expect(ValidDecimalPointValidator().validate(".") == false)
    }

    @Test func testValidDecimalPointValidatorPointMultipleDots() async throws {
        #expect(ValidDecimalPointValidator().validate("100.1.2.0") == false)
    }

    @Test func testNonEmptyValidatorNonEmpty() async throws {
        #expect(NonEmptyValidator().validate("100.0"))
    }

    @Test func testNonEmptyValidatorEmpty() async throws {
        #expect(NonEmptyValidator().validate("") == false)
    }

    @Test func testNonEmptyValidatorEmptyWhitespace() async throws {
        #expect(NonEmptyValidator().validate(" ") == false)
    }
}

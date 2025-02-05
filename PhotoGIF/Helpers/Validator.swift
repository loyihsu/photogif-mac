//
//  Validator.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/4.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

protocol Validator {
    func validate(_ string: String) -> Bool
}

extension [Validator] {
    func validate(_ string: String) -> Bool {
        !self.contains(where: { !$0.validate(string) })
    }
}

// MARK: - Validators

struct DecimalNumberOnlyValidator: Validator {
    private static let validCharacters = Set("01234567890.")

    func validate(_ string: String) -> Bool {
        !string.contains {
            !DecimalNumberOnlyValidator.validCharacters.contains($0)
        }
    }
}

struct ValidDecimalPointValidator: Validator {
    func validate(_ string: String) -> Bool {
        string.first != "." && string.last != "." && string.count(where: { $0 == "." }) <= 1
    }
}

struct NonEmptyValidator: Validator {
    func validate(_ string: String) -> Bool {
        !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

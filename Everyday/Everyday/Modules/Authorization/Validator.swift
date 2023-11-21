//
//  Validator.swift
//  Everyday
//
//  Created by Михаил on 15.11.2023.
//

import Foundation

struct PasswordValidationError {
    static let length = "Пароль должен содержать от 6 до 32 символов."
    static let lowercase = "Пароль должен содержать строчные буквы."
    static let uppercase = "Пароль должен содержать заглавные буквы."
    static let digit = "Пароль должен содержать цифры."
    static let specialCharacter = "Пароль должен содержать специальные символы: $@$#!%*?&."
}

class Validator {
    
    static func isValidEmail(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidUsername(for username: String) -> Bool {
        let username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let usernameRegEx = "\\w{4,24}"
        let usernamePred = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)
        return usernamePred.evaluate(with: username)
    }
    
    static func validatePassword(for password: String) -> [String] {
        var errors: [String] = []

        if password.count < 6 || password.count > 32 {
            errors.append(PasswordValidationError.length)
        }

        if !password.contains(where: { $0.isLowercase }) {
            errors.append(PasswordValidationError.lowercase)
        }

        if !password.contains(where: { $0.isUppercase }) {
            errors.append(PasswordValidationError.uppercase)
        }

        if !password.contains(where: { $0.isNumber }) {
            errors.append(PasswordValidationError.digit)
        }

        if !password.contains(where: { "!@#$%^&*?".contains($0) }) {
            errors.append(PasswordValidationError.specialCharacter)
        }

        return errors
    }
}

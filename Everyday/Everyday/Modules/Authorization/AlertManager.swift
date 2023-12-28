//
//  AlertManager.swift
//  Everyday
//
//  Created by Михаил on 15.11.2023.
//

import UIKit

class AlertManager {
    
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Принять", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}

// MARK: - Show Validation Alerts

extension AlertManager {
    
    public static func showInvalidEmailAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Неправильный Email", message: "Введите корректный email.")
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Неправильный пароль", message: "Пароли не совпадают. Попробуйте ещё раз.")
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController, message: String) {
        self.showBasicAlert(on: vc, title: "Неправильный пароль", message: message)
    }
    
    public static func showInvalidUsernameAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Неправильное имя пользователя", message: "Введите корректное имя пользователя.")
    }
}

// MARK: - Registration Errors

extension AlertManager {
    
    public static func showRegistrationErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Неизвестная ошибка регистрации", message: nil)
    }
    
    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Неизвестная ошибка регистрации", message: "\(error.localizedDescription)")
    }
}

// MARK: - Log In Errors

extension AlertManager {
    
    public static func showSignInErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Неизвестная ошибка при входе", message: nil)
    }
    
    public static func showSignInErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Неизвестная ошибка при входе", message: "\(error.localizedDescription)")
    }
}

// MARK: - Logout Errors

extension AlertManager {
    
    public static func showLogoutError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Ошибка при выходе из учетной записи", message: "\(error.localizedDescription)")
    }
}

// MARK: - Forgot Password

extension AlertManager {

    public static func showPasswordResetSent(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Сообщение для сброса пароля отправлено на почту", message: nil)
    }
    
    public static func showErrorSendingPasswordReset(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Ошибка при отправке сообщения", message: "\(error.localizedDescription)")
    }
}

// MARK: - Fetching User Errors

extension AlertManager {
    
    public static func showFetchingUserError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Ошибка при выводе пользователей", message: "\(error.localizedDescription)")
    }
    
    public static func showUnknownFetchingUserError(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Ошибка при выводе пользователей", message: nil)
    }
}

// MARK: - Firebase Storage Errors
extension AlertManager {
    
    public static func showStorageError(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Ошибка при сохранении или загрузки фото", message: nil)
    }
    
    public static func showErrorSendingStorage(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Ошибка при сохранении или загрузки фото", message: "\(error.localizedDescription)")
    }
}

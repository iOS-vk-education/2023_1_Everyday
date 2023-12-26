//
//  NetworkError.swift
//  Everyday
//
//  Created by user on 15.12.2023.
//

import Foundation

enum NetworkError: String, Error {
    
    case invalidUser        = "Невозможно подключиться к серверу. Войдите в аккаунт."
    case unableToComplete   = "Невозможно выполнить запрос. Пожалуйста, проверьте подключение к интернету."
    case invalidResponse    = "Неверный ответ сервера. Пожалуйста, попробуйте ещё раз."
    case invalidData        = "Данные полученные с сервера неверны. Пожалуйста, попробуйте ещё раз."
}

//
//  Alert.swift
//  Everyday
//
//  Created by user on 21.11.2023.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidResponse = AlertItem(title: Text("Ошибка сервера"),
                                           message: Text("Неверный ответ от сервера. Пожалуйста, повторите попытку позже."),
                                           dismissButton: .default(Text("ОК")))
    
    static let invalidData = AlertItem(title: Text("Ошибка сервера"),
                                       message: Text("Данные, полученные с сервера, оказались недействительными. Обратитесь в службу поддержки."),
                                       dismissButton: .default(Text("ОК")))
    
    static let noData = AlertItem(title: Text("Нет данных"),
                                  message: Text("Отсутствуют данные для отображения."),
                                  dismissButton: .default(Text("ОК")))
    
    static let localIssue = AlertItem(title: Text("Ошибка устройства"),
                                      message: Text("Что-то не так с вашим устройством. Пожалуйста, обратитесь в службу поддержки."),
                                      dismissButton: .default(Text("ОК")))
    
    static let firstTime = AlertItem(title: Text("Впервые зашли в аналитику?"),
                                     message: Text("Если вы используете аналитику не в первый раз, пожалуйста, обратитесь в службу поддержки."),
                                     dismissButton: .default(Text("ОК")))
}

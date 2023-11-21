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
    static let invalidResponse = AlertItem(title: Text("Server Error"),
                                           message: Text("Invalid response from the server. Please try again later or contact support."),
                                           dismissButton: .default(Text("OK")))
    
    static let invalidData = AlertItem(title: Text("Server Error"),
                                       message: Text("The data received from the server was invalid. Please contact support."),
                                       dismissButton: .default(Text("OK")))
    
    static let noData = AlertItem(title: Text("Empty storage"),
                                  message: Text("You have no data to show."),
                                  dismissButton: .default(Text("OK")))
    
    static let localStorageIssue = AlertItem(title: Text("Device Error"),
                                             message: Text("Something is wrong with your device. Please contact support."),
                                             dismissButton: .default(Text("OK")))
}

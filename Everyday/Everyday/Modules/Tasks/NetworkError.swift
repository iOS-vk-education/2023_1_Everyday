//
//  NetworkError.swift
//  Everyday
//
//  Created by user on 15.12.2023.
//

import Foundation

enum NetworkError: String, Error {
    
    case invalidUser        = "Unable to connect to the server. Log in to save your data on server."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection."
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Try again"
}

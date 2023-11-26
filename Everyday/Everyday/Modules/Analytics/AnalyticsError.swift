//
//  AnalyticsError.swift
//  Everyday
//
//  Created by user on 21.11.2023.
//

import Foundation

enum AnalyticsError: Error {
    case invalidResponse
    case invalidData
    case noData
    case localStorageIssue
}

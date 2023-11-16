//
//  Date+Ext.swift
//  Everyday
//
//  Created by user on 12.11.2023.
//

import Foundation

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components) ?? Date()
    }
}

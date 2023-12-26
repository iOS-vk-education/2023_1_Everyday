//
//  Calendar.Component+Ext.swift
//  Everyday
//
//  Created by user on 25.12.2023.
//

import Foundation

extension Calendar.Component {
    
    static func fromString(_ componentString: String) -> Calendar.Component {
        let componentMapping: [String: Calendar.Component] = [
            "день": .day,
            "месяц": .month,
            "неделя": .weekOfYear
        ]

        return componentMapping[componentString.lowercased()] ?? .day
    }
}

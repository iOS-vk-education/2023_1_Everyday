//
//  Priority+Ext.swift
//  Everyday
//
//  Created by user on 12.12.2023.
//

import UIKit

extension Priority {
    
    func convertToString() -> String {
        let stringMapping: [Priority: String] = [
            .high: "Важно",
            .medium: "Срочно",
            .low: "Не важно",
            .none: "Без приоритета"
        ]

        return stringMapping[self] ?? "Без приоритета"
    }
    
    func convertToUIColor() -> UIColor {
        let colorMapping: [Priority: UIColor] = [
            .high: UIColor.systemRed,
            .medium: UIColor.systemYellow,
            .low: UIColor.systemGreen,
            .none: UIColor.clear
        ]

        return colorMapping[self] ?? UIColor.clear
    }
}

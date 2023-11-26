//
//  Color+Ext.swift
//  Everyday
//
//  Created by user on 22.11.2023.
//

import SwiftUI

extension Color {
    static let brandPrimary = Color("EverydayBlue")
    static let brandPrimaryLight = Color("EverydayLightBlue")
    static let brandSecondary = Color("EverydayOrange")
}

extension UIColor {
    static let brandPrimary = UIColor(named: "EverydayBlue") ?? UIColor.systemBlue
    static let brandPrimaryLight = UIColor(named: "EverydayLightBlue") ?? UIColor.systemTeal
    static let brandSecondary = UIColor(named: "EverydayOrange") ?? UIColor.systemOrange
}

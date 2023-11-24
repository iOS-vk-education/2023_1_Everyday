//
//  Color+Ext.swift
//  Everyday
//
//  Created by user on 22.11.2023.
//

import SwiftUI

extension Color {
    static let brandPrimary = Color("EverydayBlue")
    static let brandSecondary = Color("EverydayOrange")
}

extension UIColor {
    static let brandPrimary = UIColor(named: "EverydayBlue") ?? UIColor.systemBlue
    static let brandSecondary = UIColor(named: "EverydayOrange") ?? UIColor.systemOrange
}

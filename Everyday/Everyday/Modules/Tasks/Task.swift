//
//  Task.swift
//  Everyday
//
//  Created by user on 08.12.2023.
//

import UIKit

struct Task: Codable, Identifiable, Hashable {
    var id = UUID()
    let startTime: Date
    let endTime: Date
    let taskName: String
    let taskTag: Int
}

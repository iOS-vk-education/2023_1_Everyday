//
//  ChartGridViewModel.swift
//  Everyday
//
//  Created by user on 11.11.2023.
//

import SwiftUI

final class ChartGridViewModel: ObservableObject {
    
    var selectedChart: Priority? {
        didSet {
            isShowingDetailView = true
        }
    }
    
    @Published var isShowingDetailView = false
    @Published var chartTypes: [GridCell] = [
        GridCell(name: "Important", chartType: .bar),
        GridCell(name: "Urgent", chartType: .bar),
        GridCell(name: "Low prio", chartType: .bar),
        GridCell(name: "Unnecessary", chartType: .bar)
    ]
}

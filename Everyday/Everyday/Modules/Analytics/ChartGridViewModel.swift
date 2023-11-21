//
//  ChartGridViewModel.swift
//  Everyday
//
//  Created by user on 11.11.2023.
//

import SwiftUI

final class ChartGridViewModel: ObservableObject {
    
    @Published var isShowingDetailView = false
    
    @AppStorage("chartTypes") private var chartTypesData: Data?
    @Published var chartTypes: [GridCell] = [
        GridCell(name: "Important", chartType: .bar),
        GridCell(name: "Urgent", chartType: .bar),
        GridCell(name: "Low prio", chartType: .bar),
        GridCell(name: "Unnecessary", chartType: .bar)
    ]
    
    func saveChanges() {
        do {
            let data = try JSONEncoder().encode(chartTypes)
            chartTypesData = data
            print("Successfully saved preferences in UserDefaults")
        } catch {
            // ERROR
            print("Something went wrong with saving preferences in UserDefaults")
        }
    }
    
    func retrievePreferences() {
        guard let chartTypesData = chartTypesData else {
            return
        }
        
        do {
            chartTypes = try JSONDecoder().decode([GridCell].self, from: chartTypesData)
            print("Successfully retrieved preferences from UserDefaults")
        } catch {
            // ERROR
            print("Something went wrong with retrieving preferences from UserDefaults")
        }
    }
    
    var selectedChart: Priority? {
        didSet {
            isShowingDetailView = true
        }
    }
}

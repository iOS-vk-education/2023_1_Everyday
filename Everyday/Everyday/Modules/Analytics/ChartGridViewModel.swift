//
//  ChartGridViewModel.swift
//  Everyday
//
//  Created by user on 11.11.2023.
//

import SwiftUI
import FirebaseFirestore

final class ChartGridViewModel: ObservableObject {
    
    @Published var isShowingDetailView = false
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    
    @Published var taskData: [TaskData] = []
    @AppStorage("chartTypes") private var chartTypesData: Data?
    @Published var chartTypes: [GridCell] = [
        GridCell(name: "Срочно", chartType: .bar),
        GridCell(name: "Важно", chartType: .bar),
        GridCell(name: "Не важно", chartType: .bar),
        GridCell(name: "Без приоритета", chartType: .bar)
    ]
    
    func getTaskData() {
        isLoading = true
        TaskService.shared.fetchUser { [self] user, error in
            DispatchQueue.main.async { [self] in
                isLoading = false
                guard error == nil else {
                    alertItem = AlertContext.invalidResponse
                    return
                }
                guard let doneTaskIds = user?.doneTaskIds else {
                    alertItem = AlertContext.noData
                    return
                }
                
                for taskReference in doneTaskIds {
                    taskReference.getDocument { [self] document, error in
                        guard error == nil else {
                            alertItem = AlertContext.invalidResponse
                            return
                        }
                        guard let document = document,
                              let taskData = document.data(),
                              let timestamp = taskData["date"] as? Timestamp,
                              let priorityArray = taskData["priority"] as? NSArray else {
                            alertItem = AlertContext.invalidData
                            return
                        }
                        
                        let date = timestamp.dateValue()
                        let priority = priorityArray.compactMap { $0 as? Int }
                        
                        self.taskData.append(.init(date: date, priority: priority))
                        self.taskData.sort { $0.date < $1.date }
                    }
                }
            }
        }
    }
    
    func saveChanges() {
        do {
            let data = try JSONEncoder().encode(chartTypes)
            chartTypesData = data
        } catch {
            alertItem = AlertContext.localStorageIssue
        }
    }
    
    func retrievePreferences() {
        guard let chartTypesData = chartTypesData else {
            return
        }
        
        do {
            chartTypes = try JSONDecoder().decode([GridCell].self, from: chartTypesData)
        } catch {
            alertItem = AlertContext.localStorageIssue
        }
    }
    
    var selectedChart: Priority? {
        didSet {
            isShowingDetailView = true
        }
    }
}

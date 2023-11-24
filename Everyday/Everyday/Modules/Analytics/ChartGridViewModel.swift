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
//    @Published var isLoading = false
    
    @Published var taskData: [TaskData] = []
    @AppStorage("chartTypes") private var chartTypesData: Data?
    @Published var chartTypes: [GridCell] = [
        GridCell(name: "Срочно", chartType: .bar, barUnit: .day),
        GridCell(name: "Важно", chartType: .bar, barUnit: .day),
        GridCell(name: "Не важно", chartType: .bar, barUnit: .day),
        GridCell(name: "Без приоритета", chartType: .bar, barUnit: .day)
    ]
    
    func getTaskData() {
//        isLoading = true
        var tasksProcessed = 0
        TaskService.shared.fetchUser { [self] user, error in
            DispatchQueue.main.async { [self] in
//                isLoading = false
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
                              let taskDocumentData = document.data(),
                              let timestamp = taskDocumentData["date"] as? Timestamp,
                              let priorityArray = taskDocumentData["priority"] as? NSArray else {
                            alertItem = AlertContext.invalidData
                            return
                        }
                        
                        let date = timestamp.dateValue()
                        let priority = priorityArray.compactMap { $0 as? Int }
                        
                        self.taskData.append(.init(date: date, priority: priority))
                        tasksProcessed += 1
                        
                        if tasksProcessed == doneTaskIds.count {
                            self.taskData.sort { $0.date < $1.date }
                            animateGraph()
                        }
                    }
                }
            }
        }
    }
    
    func animateGraph() {
        for index in self.taskData.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    self.taskData[index].animate = true
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

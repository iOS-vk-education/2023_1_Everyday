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
    var selectedChartIndex: Int? {
        didSet {
            isShowingDetailView = true
        }
    }
    
    @Published var alertItem: AlertItem?
    
    @Published var taskData: [TaskData] = []
    @AppStorage("chartTypes") private var chartTypesData: Data?
    @Published var chartTypes: [GridCell] = [
        GridCell(name: "Срочно", chartType: .bar, barUnit: .day),
        GridCell(name: "Важно", chartType: .bar, barUnit: .day),
        GridCell(name: "Не важно", chartType: .bar, barUnit: .day),
        GridCell(name: "Без приоритета", chartType: .bar, barUnit: .day)
    ]
    
    func getTaskData() {
        let group = DispatchGroup()
        TaskService.shared.fetchUser { [self] user, error in
                guard error == nil else {
                    alertItem = AlertContext.invalidResponse
                    return
                }
                guard let doneTaskIds = user?.doneTaskIds else {
                    alertItem = AlertContext.noData
                    return
                }
                
                for taskReference in doneTaskIds {
                    group.enter()
                    taskReference.getDocument { [self] document, error in
                        defer {
                            group.leave()
                        }
                        
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
                    }
                }
            group.notify(queue: .main) {
                self.taskData.sort { $0.date < $1.date }
                self.animateGraph()
            }
        }
    }
    
    func filteredData(by unit: BarUnit) -> [TaskData] {
        var filteredTaskData: [TaskData] = []
        
        let currentDate = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        switch unit {
        case .day:
            dateComponents.day = -7
        case .week:
            dateComponents.weekOfYear = -7
        case .month:
            dateComponents.month = -7
        }
        
        guard let timeAgo = calendar.date(byAdding: dateComponents, to: currentDate) else {
            alertItem = AlertContext.localStorageIssue  // change
            return []
        }
        filteredTaskData = self.taskData.filter { $0.date >= timeAgo }
        
        return filteredTaskData
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
}

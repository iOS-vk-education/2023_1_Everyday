//
//  ChartGridView.swift
//  Everyday
//
//  Created by user on 10.11.2023.
//

import SwiftUI
import Charts
import FirebaseFirestore

struct ChartGridView: View {
    
    @StateObject var viewModel = ChartGridViewModel()
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible())]
    @State var taskData: [TaskData] = []
    
    var body: some View {
        NavigationView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.chartTypes.indices, id: \.self) { index in
                    ChartTitleView(name: viewModel.chartTypes[index].name,
                                   index: index,
                                   chartType: viewModel.chartTypes[index].chartType,
                                   taskDatas: taskData)
                    .onTapGesture {
                        viewModel.selectedChart = Priority(rawValue: index)
                    }
                }
            }
            .onAppear {
                getTaskData()
                
                viewModel.retrievePreferences()
            }
            .sheet(isPresented: $viewModel.isShowingDetailView) {
                ChartDetailView(index: viewModel.selectedChart?.rawValue ?? 0,
                                taskDatas: taskData,
                                viewModel: viewModel)
            }
        }
    }
    
    func getTaskData() {
        TaskService.shared.fetchUser { user, error in
            DispatchQueue.main.async {
                if error != nil {
                    // ERROR
                    print("Error Fetching User")
                    return
                }
                // ERROR no data
                for taskReference in user?.doneTaskIds ?? [] {
                    taskReference.getDocument { document, error in
                        if error != nil {
                            // ERROR
                            print("Error Fetching Document")
                        } else if let document = document {
                            if let taskData = document.data(),
                               let timestamp = taskData["date"] as? Timestamp,
                               let priorityArray = taskData["priority"] as? NSArray {
                                
                                let date = timestamp.dateValue()
                                let priority = priorityArray.compactMap { $0 as? Int }
                                
                                self.taskData.append(.init(date: date, priority: priority))
                                self.taskData.sort { $0.date < $1.date }
                            } else {
                                // ERROR
                                print("Error decoding Document: Incorrect types or missing values")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ChartTitleView: View {
    
    let name: String
    let index: Int
    let chartType: ChartType
    let taskDatas: [TaskData]
    
    var body: some View {
        VStack {
            Text(name)
                .font(.title2)
                .fontWeight(.semibold)
            Chart {
                RuleMark(y: .value("Goal", 8))
                    .foregroundStyle(.pink.gradient)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .annotation(alignment: .leading) {
                        Text("Goal")
                            .font(.caption)
                            .foregroundColor(.pink)
                    }
                
                ForEach(taskDatas) { taskData in
                    switch chartType {
                    case .line:
                        LineMark(
                            x: .value("Month", taskData.date, unit: .month),
                            y: .value("Tasks", taskData.priority[index])
                        )
                        .foregroundStyle(Color.pink.gradient)
                    case .bar:
                        BarMark(
                            x: .value("Month", taskData.date, unit: .month),
                            y: .value("Tasks", taskData.priority[index])
                        )
                        .foregroundStyle(Color.pink.gradient)
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: taskDatas.map { $0.date }) { _ in
                    // so there are no labels
                }
            }
            .chartYAxis {
                AxisMarks { _ in
                    // so there are no labels
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height / 3)
        .padding()
        .background(Color.mint)
        .cornerRadius(10.0)
    }
}

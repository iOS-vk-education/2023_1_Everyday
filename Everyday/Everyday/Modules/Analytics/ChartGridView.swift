//
//  ChartGridView.swift
//  Everyday
//
//  Created by user on 10.11.2023.
//

import SwiftUI
import Charts

struct ChartGridView: View {
    
    @StateObject var viewModel = ChartGridViewModel()
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible())]
    let taskData: [TaskData] = MockData.newExample
    
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
                viewModel.retrievePreferences()
            }
            .sheet(isPresented: $viewModel.isShowingDetailView) {
                ChartDetailView(index: viewModel.selectedChart?.rawValue ?? 0,
                                taskDatas: taskData,
                                viewModel: viewModel)
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

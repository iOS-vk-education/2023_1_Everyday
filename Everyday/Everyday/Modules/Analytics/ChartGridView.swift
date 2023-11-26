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
    
    @State private var selectedBarUnit: BarUnit = .month
    
    var body: some View {
        NavigationView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.chartTypes.indices, id: \.self) { index in
                    ChartTitleView(name: viewModel.chartTypes[index].name,
                                   index: index,
                                   chartType: viewModel.chartTypes[index].chartType,
                                   viewModel: viewModel)
                    .onTapGesture {
                        viewModel.selectedChartIndex = index
                    }
                }
            }
            .onAppear {
                viewModel.taskData.removeAll(keepingCapacity: true)
                viewModel.getTaskData()
                
                viewModel.retrievePreferences()
                selectedBarUnit = viewModel.chartTypes[0].barUnit
            }
            .sheet(isPresented: $viewModel.isShowingDetailView) {
                ChartDetailView(index: viewModel.selectedChartIndex ?? 0,
                                viewModel: viewModel)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.brandPrimary)
            .toolbar {
                Menu {
                    Picker(selection: $selectedBarUnit, label: Text("Bar units")) {
                        ForEach(BarUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue)
                        }
                    }
                } label: {
                    Label("Bar unit", systemImage: "chart.bar.fill")
                        .tint(.brandSecondary)
                }
                .onChange(of: selectedBarUnit) { newBarUnit in
                    for i in 0..<viewModel.chartTypes.count {
                        viewModel.chartTypes[i].barUnit = newBarUnit
                    }
                    for i in 0..<viewModel.taskData.count {
                        viewModel.taskData[i].animate = false
                    }
                    viewModel.animateGraph()
                }
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
}

struct ChartTitleView: View {
    
    let name: String
    let index: Int
    let chartType: ChartType
    @ObservedObject var viewModel: ChartGridViewModel
    
    var body: some View {
        VStack {
            Text(name)
                .font(.title2)
                .fontWeight(.semibold)
            Chart {
                RuleMark(y: .value("Goal", 8))
                    .foregroundStyle(Color.brandSecondary)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .annotation(alignment: .leading) {
                        Text("Goal")
                            .font(.caption)
                            .foregroundColor(.brandSecondary)
                    }
                
                ForEach(viewModel.taskData) { taskData in
                    switch chartType {
                    case .line:
                        LineMark(
                            x: .value("Month", taskData.date, unit: Calendar.Component.fromString(viewModel.chartTypes[index].barUnit.rawValue)),
                            y: .value("Tasks", taskData.animate ? taskData.priority[index] : 0)
                        )
                        .foregroundStyle(Color.brandSecondary)
                        .interpolationMethod(.catmullRom)
                    case .bar:
                        BarMark(
                            x: .value("Month", taskData.date, unit: Calendar.Component.fromString(viewModel.chartTypes[index].barUnit.rawValue)),
                            y: .value("Tasks", taskData.animate ? taskData.priority[index] : 0)
                        )
                        .foregroundStyle(Color.brandSecondary)
                    }
                    
                    if chartType == .line {
                        AreaMark(
                            x: .value("Month", taskData.date, unit: Calendar.Component.fromString(viewModel.chartTypes[index].barUnit.rawValue)),
                            y: .value("Tasks", taskData.animate ? taskData.priority[index] : 0)
                        )
                        .foregroundStyle(Color.brandSecondary.opacity(0.1))
                        .interpolationMethod(.catmullRom)
                    }
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
        }
        .frame(height: UIScreen.main.bounds.height / 3)
        .padding()
        .background(Color.brandPrimaryLight)
        .cornerRadius(10.0)
    }
}

//
//  ChartDetailView.swift
//  Everyday
//
//  Created by user on 11.11.2023.
//

import SwiftUI
import Foundation
import Charts

struct ChartDetailView: View {
    
    let index: Int
    @ObservedObject var viewModel: ChartGridViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Spacer()
                
                Button {
                    viewModel.isShowingDetailView = false
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .tint(.brandPrimaryLight)
                }
                .font(.system(size: 32))
            }
            .padding(EdgeInsets(top: 16, leading: 0, bottom: -16, trailing: 16))
            
            Text(viewModel.chartTypes[index].name)
                .padding()
                .font(.largeTitle)
            
            VStack {
                
                Chart {
                    RuleMark(y: .value("Goal", 8))
                        .foregroundStyle(Color.brandSecondary)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .annotation(alignment: .leading) {
                            Text("Goal")
                                .font(.caption)
                                .foregroundColor(Color.brandSecondary)
                        }
                    
                    ForEach(viewModel.taskData) { taskData in
                        switch viewModel.chartTypes[index].chartType {
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
                        
                        if viewModel.chartTypes[index].chartType == .line {
                            AreaMark(
                                x: .value("Month", taskData.date, unit: Calendar.Component.fromString(viewModel.chartTypes[index].barUnit.rawValue)),
                                y: .value("Tasks", taskData.animate ? taskData.priority[index] : 0)
                            )
                            .foregroundStyle(Color.brandSecondary.opacity(0.1))
                            .interpolationMethod(.catmullRom)
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: viewModel.taskData.map { $0.date }) { _ in
                        AxisValueLabel(format: .dateTime.month(.narrow), horizontalSpacing: 20)
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                        AxisGridLine()
                    }
                }
                .padding()
                
                HStack {
                    Text("Chart type")
                    
                    Picker("", selection: $viewModel.chartTypes[index].chartType) {
                        ForEach(ChartType.allCases, id: \.self) { chartType in
                            Text(chartType.rawValue).tag(chartType)
                        }
                    }
                    .onChange(of: viewModel.chartTypes[index].chartType) { _ in
                        viewModel.saveChanges()
                        for i in 0..<viewModel.taskData.count {
                            viewModel.taskData[i].animate = false
                        }
                        viewModel.animateGraph()
                    }
                    .pickerStyle(.segmented)
                    .padding(.leading, 80)
                }
                .padding()
            }
            .padding()
        }
        .background(Color.brandPrimary)
    }
}

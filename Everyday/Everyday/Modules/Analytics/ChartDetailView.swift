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
            Text(viewModel.chartTypes[index].name)
                .padding()
                .font(.title)
            
            VStack {
                HStack {
                    Text("Chart type")
                    
                    Picker("", selection: $viewModel.chartTypes[index].chartType) {
                        ForEach(ChartType.allCases, id: \.self) { chartType in
                            Text(chartType.rawValue).tag(chartType)
                        }
                    }
                    .onChange(of: viewModel.chartTypes[index].chartType) { _ in
                        viewModel.saveChanges()
                    }
                    .pickerStyle(.segmented)
                }
                
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
                                y: .value("Tasks", taskData.priority[index])
                            )
                            .foregroundStyle(Color.pink.gradient)
                        case .bar:
                            BarMark(
                                x: .value("Month", taskData.date, unit: Calendar.Component.fromString(viewModel.chartTypes[index].barUnit.rawValue)),
                                y: .value("Tasks", taskData.priority[index])
                            )
                            .foregroundStyle(Color.brandSecondary)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.brandPrimary)
    }
}

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
    let viewMonth: [ViewMonth]
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
                    .onChange(of: viewModel.chartTypes[index].chartType) { newChartType in
                        viewModel.saveChanges()
                    }
                    .pickerStyle(.segmented)
                }
                
                Chart {
                    RuleMark(y: .value("Goal", 8))
                        .foregroundStyle(.pink.gradient)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .annotation(alignment: .leading) {
                            Text("Goal")
                                .font(.caption)
                                .foregroundColor(.pink)
                        }
                    
                    ForEach(viewMonth) { viewMonth in
                        switch viewModel.chartTypes[index].chartType {
                        case .line:
                            LineMark(
                                x: .value("Month", viewMonth.date, unit: .month),
                                y: .value("Views", viewMonth.viewCount)
                            )
                            .foregroundStyle(Color.pink.gradient)
                        case .bar:
                            BarMark(
                                x: .value("Month", viewMonth.date, unit: .month),
                                y: .value("Views", viewMonth.viewCount)
                            )
                            .foregroundStyle(Color.pink.gradient)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

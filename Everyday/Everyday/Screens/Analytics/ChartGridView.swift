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
    let viewMonth: [[ViewMonth]] = MockData.viewMonth
    
    var body: some View {
        NavigationView {
            LazyVGrid(columns: columns) {
                ForEach(viewMonth, id: \.self) { data in
                    ChartTitleView(name: viewModel.chartTypes[viewMonth.firstIndex(of: data) ?? 0].name, chartType: viewModel.chartTypes[viewMonth.firstIndex(of: data) ?? 0].chartType, viewMonth: data)
                        .onTapGesture {
                            viewModel.selectedChart = Priority(rawValue: (viewMonth.firstIndex(of: data) ?? 0))
                        }
                }
            }
            .onAppear() {
                viewModel.retrievePreferences()
            }
            .sheet(isPresented: $viewModel.isShowingDetailView) {
                ChartDetailView(index: viewModel.selectedChart?.rawValue ?? 0, viewMonth: viewMonth[viewModel.selectedChart?.rawValue ?? 0], viewModel: viewModel)
            }
        }
    }
}

struct ChartTitleView: View {
    let name: String
    let chartType: ChartType
    let viewMonth: [ViewMonth]
    
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
                    
                    ForEach(viewMonth) { viewMonth in
                        switch chartType {
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
                .chartXAxis {
                    AxisMarks(values: viewMonth.map { $0.date }) { date in
                        // so there are no labels
                    }
                }
                .chartYAxis {
                    AxisMarks { mark in
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

//
//  ChartGridView.swift
//  Everyday
//
//  Created by user on 10.11.2023.
//

import SwiftUI
import Charts

// TODO: figure out how GeometryReader works

struct ChartGridView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible())]
    let viewMonth: [[ViewMonth]] = [
        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .high),
        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .high),
        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .high),
        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .high),
        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .high),
        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .high),
        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .high),],
        
        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 1, priority: .medium),
        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 2, priority: .medium),
        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 3, priority: .medium),
        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 4, priority: .medium),
        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 5, priority: .medium),
        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 6, priority: .medium),
        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 7, priority: .medium),],
        
        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 7, priority: .low),
        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .low),
        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 5, priority: .low),
        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 4, priority: .low),
        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .low),
        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 2, priority: .low),
        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 1, priority: .low),],
        
        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .none),
        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .none),
        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .none),
        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .none),
        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .none),
        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .none),
        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .none),],
    ]
    
    var body: some View {
        NavigationView {
            LazyVGrid(columns: columns) {
                ForEach(viewMonth, id: \.self) { data in
                    ChartTitleView(name: "Priority", chartType: .bar, viewMonth: data)
                }
            }
            .navigationTitle("Analytics")
        }
    }
}

struct ChartGridView_Previews: PreviewProvider {
    static var previews: some View {
        ChartGridView()
    }
}

struct ChartTitleView: View {
    let name: String
    let chartType: ChartType
    let viewMonth: [ViewMonth]
    
    var body: some View {
//        GeometryReader { geometry in
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
            .frame(height: 300)
            .padding()
            .background(Color.mint)
            .cornerRadius(10.0)
//        }
    }
}

enum ChartType {
    case bar
    case line
//    case pie
}

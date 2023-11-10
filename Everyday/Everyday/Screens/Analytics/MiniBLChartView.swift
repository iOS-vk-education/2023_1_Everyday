//
//  MiniBLChartView.swift
//  Everyday
//
//  Created by user on 09.11.2023.
//

import SwiftUI
import Foundation
import Charts

// TODO: create basic class

struct MiniBLChartView: View {
    
    let viewMonth: [ViewMonth]
    var chartType: ChartType
    
    var body: some View {
        VStack() {
            
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
            .padding(.bottom)
        }
        .padding()
        .background(Color.mint)
        .cornerRadius(10.0)
    }
}

//struct MiniBLChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        MiniBLChartView(isLineGraph: false)
//    }
//}

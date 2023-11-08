//
//  MiniBLChartView.swift
//  Everyday
//
//  Created by user on 09.11.2023.
//

import SwiftUI
import Foundation
import Charts

struct MiniBLChartView: View {
    
    let viewMonth: [ViewMonth] = [
        .init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5),
        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6),
        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2),
        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11),
        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3),
        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5),
        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10),
    ]
    
    @State var isLineGraph: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Youtube Views")
            
            Toggle("Line Graph", isOn: $isLineGraph)
            
            Text("Total: \(viewMonth.reduce(0, { $0 + $1.viewCount }))")
                .fontWeight(.semibold)
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.bottom, 12)
            
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
                    if isLineGraph {
                        LineMark(
                            x: .value("Month", viewMonth.date, unit: .month),
                            y: .value("Views", viewMonth.viewCount)
                        )
                        .foregroundStyle(Color.pink.gradient)
                    } else {
                        BarMark(
                            x: .value("Month", viewMonth.date, unit: .month),
                            y: .value("Views", viewMonth.viewCount)
                        )
                        .foregroundStyle(Color.pink.gradient)
                    }
                }
            }
//            .frame(height: 180)  // hard code for now -> change for collection cell size
//            .chartPlotStyle { plotContent in
//                plotContent
//                    .background(.mint.gradient.opacity(0.3))
//            }
//            .chartXAxis {
//                AxisMarks(values: viewMonth.map { $0.date }) { date in
//                    AxisGridLine()
//                    AxisTick()
//                    AxisValueLabel(format: .dateTime.month(.narrow), horizontalSpacing: 12)  // hard code, because didn't find another solution to show the last column label, but the number changes for every device
//                }
//            }
//            .chartYAxis {
//                AxisMarks { mark in
//                    AxisValueLabel()
//                    AxisGridLine()
//                }
//            }
//            .padding(.bottom)
//            HStack {
//                Image(systemName: "line.diagonal")
//                    .rotationEffect(Angle(degrees: 45))
//                    .foregroundColor(.mint)
//
//                Text("Monthly Goal")
//                    .foregroundColor(.secondary)
//            }
//            .font(.caption2)
//            .padding(.leading, 4)
        }
        .padding()
        .background(Color.mint)
        .cornerRadius(10.0)
    }
}

//struct MiniBLChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        MiniBLChartView()
//    }
//}

//struct ViewMonth: Identifiable {
//    var id = UUID()
//    var date: Date
//    var viewCount: Int
//}
//
//extension Date {
//    static func from(year: Int, month: Int, day: Int) -> Date {
//        let components = DateComponents(year: year, month: month, day: day)
//        return Calendar.current.date(from: components)!
//    }
//}


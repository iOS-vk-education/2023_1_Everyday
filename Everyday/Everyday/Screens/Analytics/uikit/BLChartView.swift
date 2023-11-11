//
//  BLChartView.swift
//  Everyday
//
//  Created by user on 09.11.2023.
//

import SwiftUI
import Foundation
import Charts

//struct BLChartView: View {
//    
////    let viewMonth: [ViewMonth]
//    var chartType: ChartType
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text("Youtube Views")
//            
//            Text("Total: \(viewMonth.reduce(0, { $0 + $1.viewCount }))")
//                .fontWeight(.semibold)
//                .font(.footnote)
//                .foregroundColor(.secondary)
//                .padding(.bottom, 12)
//            
//            Chart {
//                RuleMark(y: .value("Goal", 8))
//                    .foregroundStyle(.pink.gradient)
//                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
//                    .annotation(alignment: .leading) {
//                        Text("Goal")
//                            .font(.caption)
//                            .foregroundColor(.pink)
//                    }
//                
//                ForEach(viewMonth) { viewMonth in
//                    switch chartType {
//                    case .line:
//                        LineMark(
//                            x: .value("Month", viewMonth.date, unit: .month),
//                            y: .value("Views", viewMonth.viewCount)
//                        )
//                        .foregroundStyle(Color.pink.gradient)
//                    case .bar:
//                        BarMark(
//                            x: .value("Month", viewMonth.date, unit: .month),
//                            y: .value("Views", viewMonth.viewCount)
//                        )
//                        .foregroundStyle(Color.pink.gradient)
//                    }
//                }
//            }
//            //            .frame(height: 180)  // hard code for now -> change for collection cell size
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
//        }
//        .padding()
//        .background(Color.mint)
//        .cornerRadius(10.0)
//    }
//}

//struct BLChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        BLChartView()
//    }
//}

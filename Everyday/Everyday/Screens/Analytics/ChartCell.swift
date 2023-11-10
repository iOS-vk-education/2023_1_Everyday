//
//  ChartCell.swift
//  Everyday
//
//  Created by user on 08.11.2023.
//

import UIKit
import SwiftUI

// FIXME: move this protocol to basic class

protocol ChartCellDelegate {
    func didChooseChart(chartType: ChartType)
}

class ChartCell: UICollectionViewCell {
    
    static let reuseID = "ChartCell"
    var chartHostingController: UIHostingController<MiniBLChartView>?
    var delegate: ChartCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        set(chartType: , data: <#T##[ViewMonth]#>)
    }
    
    func set(chartType: ChartType, data: [ViewMonth]) {
        chartHostingController = UIHostingController(rootView: MiniBLChartView(viewMonth: data, chartType: chartType))
        guard let chartHostingController = chartHostingController,
              let chartView = chartHostingController.view else {
            return
        }
        
        addSubview(chartView)
        chartView.pinToEdges(of: self)
    }
}

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
    var chartViewController: UIHostingController<MiniBLChartView>?
    var delegate: ChartCellDelegate?
    
    func set(chartType: ChartType, data: [ViewMonth]) {
        chartViewController = UIHostingController(rootView: MiniBLChartView(chartType: chartType, data: data))
        guard let chartView = chartViewController.view else {
            return
        }
        
        addSubview(chartView)
        chartView.pinToEdges(of: self)
    }
}

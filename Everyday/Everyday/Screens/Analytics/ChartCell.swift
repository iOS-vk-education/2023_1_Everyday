//
//  ChartCell.swift
//  Everyday
//
//  Created by user on 08.11.2023.
//

import UIKit
import SwiftUI

class ChartCell: UICollectionViewCell {
    
    static let reuseID = "ChartCell"
    
    let chartViewController = UIHostingController(rootView: MiniBLChartView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard let chartView = chartViewController.view else {
            return
        }
        
        addSubview(chartView)
        chartView.pinToEdges(of: self)
    }
}

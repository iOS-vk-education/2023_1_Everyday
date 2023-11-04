//
//  AnalyticsVC.swift
//  Everyday
//
//  Created by user on 03.11.2023.
//

import UIKit
import SwiftUI

class AnalyticsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setUpView()
    }
    
    func setUpView() {
        let controller = UIHostingController(rootView: ContentView())
        
        guard let chartView = controller.view else { return }
        
        view.addSubview(chartView)
        
        chartView.pinToEdges(of: view)
    }
}

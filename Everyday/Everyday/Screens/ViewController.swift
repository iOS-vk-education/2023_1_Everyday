//
//  ViewController.swift
//  Everyday
//
//  Created by user on 28.10.2023.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green  // to check if everything is fine
        setUpView()
    }
    
    func setUpView() {
        let controller = UIHostingController(rootView: ContentView())
        
        guard let chartView = controller.view else { return }
        
        view.addSubview(chartView)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // set constraints
        ])
    }
}

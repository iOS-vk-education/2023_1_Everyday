//
//  AnalyticsVC.swift
//  Everyday
//
//  Created by user on 03.11.2023.
//

import UIKit
import SwiftUI

class AnalyticsVC: UIViewController {
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.pinToEdges(of: view)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ChartCell.self, forCellWithReuseIdentifier: ChartCell.reuseID)
    }
}

extension AnalyticsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCell.reuseID, for: indexPath) as? ChartCell else {
            fatalError("Failed to dequeue ChartCell in AnalyticsVC")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destVC = UIHostingController(rootView: BLChartView())
        navigationController?.pushViewController(destVC, animated: true)
    }
}

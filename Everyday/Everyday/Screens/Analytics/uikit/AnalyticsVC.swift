////
////  AnalyticsVC.swift
////  Everyday
////
////  Created by user on 03.11.2023.
////
//
//import UIKit
//import SwiftUI
//
//// TODO: conform to protocol
//// TODO: implement pie chart
//
//enum ChartType {
//    case bar
//    case line
////    case pie
//}
//
//class AnalyticsVC: UIViewController {
//    
////    let viewMonth: [ViewMonth] = [
////        .init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .high),
////        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .high),
////        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .high),
////        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .high),
////        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .high),
////        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .high),
////        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .high),
////        
////        .init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .medium),
////        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .medium),
////        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .medium),
////        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .medium),
////        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .medium),
////        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .medium),
////        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .medium),
////        
////        .init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .low),
////        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .low),
////        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .low),
////        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .low),
////        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .low),
////        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .low),
////        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .low),
////        
////        .init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .none),
////        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .none),
////        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .none),
////        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .none),
////        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .none),
////        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .none),
////        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .none),
////    ]
//    var collectionView: UICollectionView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .systemBackground
//        configureCollectionView()
//    }
//    
//    func configureCollectionView() {
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
//        view.addSubview(collectionView)
//        collectionView.pinToEdges(of: view)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.backgroundColor = .systemBackground
//        collectionView.register(ChartCell.self, forCellWithReuseIdentifier: ChartCell.reuseID)
//    }
//}
//
//extension AnalyticsVC: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCell.reuseID, for: indexPath) as? ChartCell else {
//            fatalError("Failed to dequeue ChartCell in AnalyticsVC")
//        }
//        
//        return cell
//    }
//    
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        let destVC = UIHostingController(rootView: BLChartView(.bar, viewMonth.filter { $0.priority == .high }))
////        navigationController?.pushViewController(destVC, animated: true)
////    }
//}
//
//extension AnalyticsVC: ChartCellDelegate {
//    
//    func didChooseChart(chartType: ChartType) {
//        
//    }
//}

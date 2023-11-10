//
//  UIHelper.swift
//  Everyday
//
//  Created by user on 08.11.2023.
//

import UIKit

enum UIHelper {
    
    // FIXME: remove height hardcode
    
    static func createTwoColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let height = view.bounds.height - 200  // hardcode for now
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - minimumItemSpacing
        let availableHeight = height - (padding * 2) - minimumItemSpacing
        let itemWidth = availableWidth / 2
        let itemHeight = availableHeight / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        return flowLayout
    }
}

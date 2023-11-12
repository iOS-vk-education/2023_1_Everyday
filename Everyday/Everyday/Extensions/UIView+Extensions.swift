//
//  UIView+Extensions.swift
//  Everyday
//
//  Created by Михаил on 08.11.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}

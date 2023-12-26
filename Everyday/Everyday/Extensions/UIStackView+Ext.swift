//
//  UIStackView+Ext.swift
//  Everyday
//
//  Created by Михаил on 26.12.2023.
//

import UIKit

extension UIStackView {
    func addSeparator(color: UIColor) {
        let separatorView = UIView()
        separatorView.backgroundColor = color
        addArrangedSubview(separatorView)
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}

//
//  UILabel+Ext.swift
//  Everyday
//
//  Created by user on 22.12.2023.
//

import UIKit

extension UILabel {
    
    func addStrikethrough(_ strikethroughStyle: NSUnderlineStyle, strikethroughColor: UIColor = .clear) {
        guard let labelText = text else {
            return
        }
        
        let attributedText = NSMutableAttributedString(string: labelText)

        attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                    value: strikethroughStyle.rawValue,
                                    range: NSMakeRange(0, attributedText.length))
        attributedText.addAttribute(NSAttributedString.Key.strikethroughColor,
                                    value: strikethroughColor,
                                    range: NSMakeRange(0, attributedText.length))
        self.attributedText = attributedText
    }
    
    func removeStrikethrough() {
        let attributedString = NSAttributedString(string: self.text ?? "", attributes: nil)
        self.attributedText = attributedString
    }
}

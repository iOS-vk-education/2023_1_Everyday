//
//  SettingsTableViewCell.swift
//  Everyday
//
//  Created by Yaz on 27.11.2023.
//

import UIKit

final class SettingsTableViewCell: UITableViewCell {
    let cellImage = UIImageView()
    let cellLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
        setupImage()
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabels() {
        cellLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
        cellLabel.textColor = .white
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupImage() {
        cellImage.tintColor = .brandSecondary
        cellImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupContentView() {
        contentView.addSubview(cellImage)
        contentView.addSubview(cellLabel)
        
        NSLayoutConstraint.activate([
            cellImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            cellImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            cellLabel.leftAnchor.constraint(equalTo: cellImage.rightAnchor, constant: 20),
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

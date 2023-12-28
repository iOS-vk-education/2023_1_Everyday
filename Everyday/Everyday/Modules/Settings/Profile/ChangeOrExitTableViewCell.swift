//
//  ProfileCustomTableViewCell.swift
//  Everyday
//
//  Created by Yaz on 27.11.2023.
//

import UIKit

final class ChangeOrExitTableViewCell: UITableViewCell {
    let cellLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabel()
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        cellLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
        cellLabel.textColor = .white
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupContentView() {
        contentView.addSubview(cellLabel)
        
        cellLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

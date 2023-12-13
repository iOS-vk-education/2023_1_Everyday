//
//  UserNameTableViewCell.swift
//  Everyday
//
//  Created by Yaz on 28.11.2023.
//

import UIKit

class UserNameTableViewCell: UITableViewCell {
    let cellTextField = UITextField()
    let cellLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
        setupField()
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
    
    private func setupField() {
        cellTextField.font = UIFont(name: "Montserrat-Bold", size: 16)
        cellTextField.textColor = .white
        cellTextField.textAlignment = .left
        cellTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupContentView() {
        contentView.addSubview(cellTextField)
        contentView.addSubview(cellLabel)
        
        NSLayoutConstraint.activate([
            cellLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            cellLabel.widthAnchor.constraint(equalToConstant: 0.15 * contentView.bounds.width),
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            cellTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellTextField.leftAnchor.constraint(equalTo: cellLabel.rightAnchor, constant: 15),
            cellTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15)
        ])
    }
}

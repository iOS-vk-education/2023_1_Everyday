//
//  CustomViewCell.swift
//  Everyday
//
//  Created by Andrey Izibaev on 18.11.2023.
//

import UIKit

class TasksTableViewCell: UITableViewCell {
    
    static let reuseID = "TasksTableViewCell"
    
    let startTimeLabel = UILabel()
    let endTimeLabel = UILabel()
    let taskNameLabel = UILabel()
    let taskTagLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLabels()
        setupStackViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        backgroundColor = .brandPrimaryLight
    }
    
    private func setupLabels() {
        startTimeLabel.font = UIFont.systemFont(ofSize: 16)
        startTimeLabel.textAlignment = .left
        startTimeLabel.numberOfLines = 0
        
        endTimeLabel.font = UIFont.systemFont(ofSize: 16)
        endTimeLabel.textAlignment = .left
        endTimeLabel.numberOfLines = 0
        
        taskNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        taskNameLabel.textAlignment = .left
        taskNameLabel.numberOfLines = 0
        
        taskTagLabel.font = UIFont.systemFont(ofSize: 14)
        taskTagLabel.textAlignment = .left
        taskTagLabel.numberOfLines = 0
    }
    
    private func setupStackViews() {

        let stackView1 = UIStackView(arrangedSubviews: [startTimeLabel, endTimeLabel])
        stackView1.axis = .vertical
        stackView1.distribution = .fillEqually
        
        let stackView2 = UIStackView(arrangedSubviews: [taskNameLabel, taskTagLabel])
        stackView2.axis = .vertical
        stackView2.distribution = .equalSpacing
        
        contentView.addSubview(stackView1)
        contentView.addSubview(stackView2)
        
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 5
        
        NSLayoutConstraint.activate([
            stackView1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            stackView1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackView1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            stackView1.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),

            stackView2.topAnchor.constraint(equalTo: stackView1.topAnchor),
            stackView2.leadingAnchor.constraint(equalTo: stackView1.trailingAnchor, constant: -40),
            stackView2.bottomAnchor.constraint(equalTo: stackView1.bottomAnchor),
            stackView2.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7)
        ])
    }
}

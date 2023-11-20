//
//  CustomViewCell.swift
//  Everyday
//
//  Created by Andrey Izibaev on 18.11.2023.
//

import UIKit

class TasksTableViewCell: UITableViewCell {
    let startTimeLabel = UILabel()
    let endTimeLabel = UILabel()
    let taskNameLabel = UILabel()
    let taskTagLabel = UILabel()
    
    let verticalStackView = UIStackView()
    let horizontalStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
        setupStackViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabels() {
        startTimeLabel.font = UIFont.systemFont(ofSize: 16)
        startTimeLabel.textColor = UIColor.black
        startTimeLabel.textAlignment = .left
        startTimeLabel.numberOfLines = 0
        
        endTimeLabel.font = UIFont.systemFont(ofSize: 16)
        endTimeLabel.textColor = UIColor.black
        endTimeLabel.textAlignment = .left
        endTimeLabel.numberOfLines = 0
        
        taskNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        taskNameLabel.textColor = UIColor.black
        taskNameLabel.textAlignment = .center
        taskNameLabel.numberOfLines = 0
        
        taskTagLabel.font = UIFont.systemFont(ofSize: 14)
        taskTagLabel.textColor = UIColor.gray
        taskTagLabel.textAlignment = .left
        taskTagLabel.numberOfLines = 0
    }
    
    private func setupStackViews() {
        verticalStackView.addArrangedSubview(startTimeLabel)
        verticalStackView.addArrangedSubview(endTimeLabel)

        horizontalStackView.addArrangedSubview(verticalStackView)

        verticalStackView.addArrangedSubview(taskNameLabel)
        verticalStackView.addArrangedSubview(taskTagLabel)

        contentView.addSubview(horizontalStackView)
        
        startTimeLabel.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        endTimeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        endTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
        taskTagLabel.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
       
            startTimeLabel.heightAnchor.constraint(equalToConstant: 25),
            endTimeLabel.heightAnchor.constraint(equalToConstant: 25),
            taskNameLabel.heightAnchor.constraint(equalToConstant: 25),
            taskTagLabel.heightAnchor.constraint(equalToConstant: 25),
                  
            startTimeLabel.centerYAnchor.constraint(equalTo: horizontalStackView.centerYAnchor),
            endTimeLabel.centerYAnchor.constraint(equalTo: horizontalStackView.centerYAnchor),
            taskNameLabel.centerYAnchor.constraint(equalTo: horizontalStackView.centerYAnchor),
            taskTagLabel.centerYAnchor.constraint(equalTo: horizontalStackView.centerYAnchor),
                  
            startTimeLabel.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor),
            endTimeLabel.leadingAnchor.constraint(equalTo: startTimeLabel.trailingAnchor),
            taskNameLabel.leadingAnchor.constraint(equalTo: endTimeLabel.trailingAnchor),
            taskTagLabel.leadingAnchor.constraint(equalTo: taskNameLabel.trailingAnchor)
        ])
    }
}

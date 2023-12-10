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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
        setupStackViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentView.backgroundColor = selected ? .brandSecondary : .brandPrimaryLight
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    private func setupLabels() {
        startTimeLabel.font = UIFont.systemFont(ofSize: 16)
        startTimeLabel.textColor = UIColor.white
        startTimeLabel.textAlignment = .left
        startTimeLabel.numberOfLines = 0
        
        endTimeLabel.font = UIFont.systemFont(ofSize: 16)
        endTimeLabel.textColor = UIColor.white
        endTimeLabel.textAlignment = .left
        endTimeLabel.numberOfLines = 0
        
        taskNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        taskNameLabel.textColor = UIColor.white
        taskNameLabel.textAlignment = .center
        taskNameLabel.numberOfLines = 0
        
        taskTagLabel.font = UIFont.systemFont(ofSize: 14)
        taskTagLabel.textColor = UIColor.white
        taskTagLabel.textAlignment = .center
        taskTagLabel.numberOfLines = 0
    }
    
    private func setupStackViews() {

        let stackView1 = UIStackView(arrangedSubviews: [startTimeLabel, endTimeLabel])
        stackView1.axis = .vertical
        stackView1.distribution = .fillEqually
        stackView1.spacing = 5
        
        let stackView2 = UIStackView(arrangedSubviews: [taskNameLabel, taskTagLabel])
        stackView2.axis = .vertical
        stackView2.distribution = .fillEqually
        stackView2.spacing = 3
        
        contentView.addSubview(stackView1)
        contentView.addSubview(stackView2)
        
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView1.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackView1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView1.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),

            stackView2.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView2.leadingAnchor.constraint(equalTo: stackView1.trailingAnchor, constant: -40),
            stackView2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView2.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7)
        ])
    }
}

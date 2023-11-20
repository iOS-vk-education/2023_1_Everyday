//
//  TasksVC.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit

class Task {
    let startTime: String
    let endTime: String
    let taskName: String
    let taskTag: String
    
    init(startTime: String, endTime: String, taskName: String, taskTag: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.taskName = taskName
        self.taskTag = taskTag
    }
}

let dela = [
    Task(startTime: "09:00", endTime: "10:00", taskName: "Task 1", taskTag: "Tag 1"),
    Task(startTime: "10:00", endTime: "11:00", taskName: "Task 2", taskTag: "Tag 2"),
    Task(startTime: "11:00", endTime: "12:00", taskName: "Task 3", taskTag: "Tag 3"),
    Task(startTime: "-", endTime: "-", taskName: "Task 4", taskTag: "Tag 4")
]

final class TasksVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
       
    private let container = UIView()
    private let topLabel = UILabel()
    private let stackView = UIStackView()
    private let searchButton = UIButton(type: .custom)
    private let moreButton = UIButton(type: .custom)
    private let addTaskButton = UIButton(type: .custom)
    private let tableView = UITableView()
    
    let alertController = UIAlertController(title: "Поиск задачи", message: "Введите имя задачи", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "EverydayBlue")
                
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        
        setupUI()
        
        view.addSubviews(topLabel, searchButton, moreButton, stackView, tableView)
        view.addSubview(addTaskButton)
        
        setupConstraints()

        self.navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dela.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? TasksTableViewCell {
            let task = dela[indexPath.row]
            cell.startTimeLabel.text = task.startTime
            cell.endTimeLabel.text = task.endTime
            cell.taskNameLabel.text = task.taskName
            cell.taskTagLabel.text = task.taskTag
            
            return cell
        } else {
            let defaultCell = UITableViewCell()
            return defaultCell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, comletion in
            tableView.deleteRows(at: [indexPath], with: .automatic)
            comletion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    private func setupUI() {
        setupCurrentDate()
        setupButtons()
        setupStackView()
        setupTable()
    }
    
    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        stackView.addArrangedSubview(topLabel)
        stackView.addArrangedSubview(searchButton)
        stackView.addArrangedSubview(moreButton)
    }
    
    private func setupCurrentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let currentDate = dateFormatter.string(from: Date())
        topLabel.text = currentDate
        topLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        topLabel.textColor = UIColor(named: "EverydayOrange")
    }
    
    private func setupButtons() {
        searchButton.backgroundColor = .red
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        moreButton.backgroundColor = .blue
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        addTaskButton.backgroundColor = .orange
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
    }
    
    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([

            topLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            searchButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            moreButton.leadingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -45),
            moreButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            tableView.topAnchor.constraint(equalTo: topLabel.topAnchor, constant: 35),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            addTaskButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
            ])
    }
    
    @objc func searchButtonTapped() {
        searchButton.backgroundColor = .cyan
    }
    
    @objc func moreButtonTapped() {
        moreButton.backgroundColor = .brown
    }
    
    @objc func addTaskButtonTapped() {
        let addTaskVC = AddTaskVC()
        present(AddTaskVC(), animated: true, completion: nil)
    }
}

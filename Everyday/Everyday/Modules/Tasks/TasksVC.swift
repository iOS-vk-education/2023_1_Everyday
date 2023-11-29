//
//  TasksVC.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit
import Firebase

struct Task {
    let startTime: String
    let endTime: String
    let taskName: String
    let taskTag: String
}

 let dela = [
    Task(startTime: "09:00", endTime: "10:00", taskName: "Проект IOS", taskTag: "Важно"),
    Task(startTime: "10:00", endTime: "11:00", taskName: "ДЗ по вебу", taskTag: "Не важно"),
    Task(startTime: "11:00", endTime: "12:00", taskName: "Cходить в магаз", taskTag: "Срочно"),
    Task(startTime: "12:00", endTime: "13:00", taskName: "Прес качат", taskTag: "Важно"),
    Task(startTime: "13:00", endTime: "14:00", taskName: "Бегит", taskTag: "Важно"),
    Task(startTime: "", endTime: "", taskName: "Сделать дз по дизайну", taskTag: "Не важно"),
    Task(startTime: "14:00", endTime: "15:00", taskName: "атжуманя", taskTag: "Важно"),
    Task(startTime: "15:00", endTime: "16:00", taskName: "Посмотреть сериал", taskTag: "Без преоритета"),
    Task(startTime: "16:00", endTime: "17:00", taskName: "Приготовить ужин", taskTag: ""),
    Task(startTime: "17:00", endTime: "18:00", taskName: "Накатить stage3 на октаху", taskTag: "Важно"),
    Task(startTime: "18:00", endTime: "19:00", taskName: "Заскочить в чайхану", taskTag: "Срочно")
 ]

final class TasksVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate {
    
    private let container = UIView()
    private let topLabel = UILabel()
    private let addTaskButton = UIButton(type: .system)
    private let tableView = UITableView()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "EverydayBlue")
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: "CustomCell")

        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        searchButton.tintColor = UIColor(named: "EverydayOrange")
        
        let image = UIImage(named: "ellipsis")?.withTintColor(UIColor(named: "everydayOrange") ?? .black)
        let moreButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(moreButtonTapped))
        moreButton.tintColor = UIColor(named: "EverydayOrange")
        
//        let moreButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(moreButtonTapped))
        
        navigationItem.rightBarButtonItems = [moreButton, searchButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: topLabel)
        navigationItem.title = ""
        navigationItem.searchController = searchController
        
        setupUI()
        
        view.addSubview(tableView)
        view.addSubview(addTaskButton)
        
        setupConstraints()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dela.count * 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 1 {
            return 10
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 1 {
            let defaultCell = UITableViewCell()
            defaultCell.backgroundColor = UIColor(named: "EverydayBlue")
            return defaultCell
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? TasksTableViewCell {
                
                cell.startTimeLabel.text = nil
                cell.endTimeLabel.text = nil
                cell.taskNameLabel.text = nil
                cell.taskTagLabel.text = nil

                let task = dela[indexPath.row / 2]
                
                cell.startTimeLabel.text = task.startTime
                cell.endTimeLabel.text = task.endTime
                cell.taskNameLabel.text = task.taskName
                cell.taskTagLabel.text = task.taskTag
                
                cell.backgroundColor = UIColor(named: "EverydayLightBlue")
                cell.layer.cornerRadius = 10
                return cell
            } else {
                let defaultCell = UITableViewCell()
                return defaultCell
            }
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row % 2 == 0 {
            let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, comletion in
                tableView.deleteRows(at: [indexPath], with: .automatic)
                comletion(true)
            }
            return UISwipeActionsConfiguration(actions: [action])
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row % 2 == 0 {
            let action = UIContextualAction(style: .normal, title: "Done") { _, _, comletion in
                
                comletion(true)
            }
            action.backgroundColor = .systemGreen
            return UISwipeActionsConfiguration(actions: [action])
        }
        return nil
    }
    
    private func setupUI() {
        setupCurrentDate()
        setupButtons()
        setupTable()
    }
    
    private func setupCurrentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let currentDate = dateFormatter.string(from: Date())
        topLabel.text = currentDate.capitalized
        topLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        topLabel.textColor = UIColor(named: "EverydayOrange")
    }
    
    private func setupButtons() {
        let config = UIImage.SymbolConfiguration(pointSize: 60)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        addTaskButton.setImage(image, for: .normal)
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        addTaskButton.tintColor = UIColor(named: "EverydayOrange")
        addTaskButton.backgroundColor = .white
        addTaskButton.layer.cornerRadius = 55
    }
    
    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = true
        tableView.backgroundColor = UIColor(named: "EverydayBlue")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            addTaskButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            addTaskButton.widthAnchor.constraint(equalToConstant: 60),
            addTaskButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc func searchButtonTapped() {
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
    }
    
    @objc func moreButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let showCompletedTasksAction = UIAlertAction(title: "Показать выполненные задачи", style: .default) { _ in
            return
        }
        alertController.addAction(showCompletedTasksAction)
        
        let showOverdueTasksAction = UIAlertAction(title: "Показать просроченные задачи", style: .default) { _ in
            return
        }
        alertController.addAction(showOverdueTasksAction)
        
        let showTasksInOrderAction = UIAlertAction(title: "Показать задачи", style: .default) { _ in
            return
        }
        alertController.addAction(showTasksInOrderAction)
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func addTaskButtonTapped() {
            let addTaskVC = AddTaskVC()
           
            if let sheet = addTaskVC.sheetPresentationController {
                sheet.detents = [
                    .custom(identifier: .init("small"), resolver: { _ in
                        return addTaskVC.height()
                    })
                ]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 20
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersEdgeAttachedInCompactHeight = true
            }
            
            present(addTaskVC, animated: true, completion: nil)
        }
}

//
//  TasksVC.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit
import Firebase

final class TasksVC: UIViewController {
    
    private let container = UIView()
    private let topLabel = UILabel()
    private let addTaskButton = UIButton(type: .system)
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let searchController = UISearchController(searchResultsController: nil)
    
    var mainMenu = UIMenu()
    var sortMenu = UIMenu()
    var filterMenu = UIMenu()
    var sortingCategoryMenu = UIMenu()
    var filterCategoryMenu = UIMenu()
    var sortByMenu = UIMenu()
    var filterByMenu = UIMenu()
    
    enum SortingCategory: String, CaseIterable {
        case time = "По умолчанию (время начала)"
        case status = "Статус"
        case priority = "Приоритет"
    }
    
    enum SortByStatus: String, CaseIterable {
        case doneFirst = "Сначала выполненные"
        case notDoneFirst = "Сначала невыполненные"
        case overdueFirst = "Сначала просроченные"
    }
    
    enum SortByPriority: String, CaseIterable {
        case ascending = "По возрастанию"
        case descending = "По убыванию"
    }
    
    enum FilterCategory: String, CaseIterable {
        case none = "По умолчанию (выключено)"
        case status = "Статус"
        case priority = "Приоритет"
    }
    
    enum FilterByStatus: String, CaseIterable {
        case doneFirst = "Только выполненные"
        case notDoneFirst = "Только невыполненные"
        case overdueFirst = "Только просроченные"
    }
    
    enum FilterByPriority: String, CaseIterable {
        case high = "Только важные"
        case medium = "Только срочные"
        case low = "Только не важные"
        case none = "Только без приоритета"
    }
    
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "EverydayBlue")
        
        setupUI()
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        searchButton.tintColor = UIColor(named: "EverydayOrange")
        
        let image = UIImage(named: "ellipsis")?.withTintColor(UIColor(named: "everydayOrange") ?? .black)
        let moreButton = UIBarButtonItem(image: image, menu: mainMenu)
        moreButton.tintColor = UIColor(named: "EverydayOrange")
        
        navigationItem.rightBarButtonItems = [moreButton, searchButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: topLabel)
        navigationItem.title = ""
        navigationItem.searchController = searchController
        
//        setupUI()
        
        view.addSubview(tableView)
        view.addSubview(addTaskButton)
        
        setupConstraints()
        getTasks()
    }
    
    func getTasks() {
        let group = DispatchGroup()
        TaskService.shared.fetchUser { [weak self] user, error in
            guard error == nil else {
                // add alert
                return
            }
            guard let taskIds = user?.taskUID else {
                // add alert
                return
            }
            
            for taskReference in taskIds {
                group.enter()
                taskReference.getDocument { [weak self] document, error in
                    defer {
                        group.leave()
                    }
                    
                    guard error == nil else {
                        // add alert
                        return
                    }
                    guard let document = document,
                          let taskDocumentData = document.data(),
                          let startTimestamp = taskDocumentData["date_begin"] as? Timestamp,
                          let endTimestamp = taskDocumentData["date_end"] as? Timestamp,
                          let title = taskDocumentData["title"] as? String,
                          let priority = taskDocumentData["priority"] as? Int else {
                        // add alert
                        return
                    }
                    
                    let startTime = startTimestamp.dateValue()
                    let endTime = endTimestamp.dateValue()
                    let taskName = title
                    let taskTag = priority
                    
                    self?.tasks.append(.init(startTime: startTime, endTime: endTime, taskName: taskName, taskTag: taskTag))
                }
            }
            group.notify(queue: .main) {
                self?.tasks.sort { $0.startTime < $1.startTime }
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        setupCurrentDate()
        setupButtons()
        setupTable()
        setupMainMenu()
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
        addTaskButton.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        addTaskButton.tintColor = UIColor(named: "EverydayOrange")
        addTaskButton.backgroundColor = .white
        addTaskButton.layer.cornerRadius = 55
    }
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        
        tableView.backgroundColor = UIColor(named: "EverydayBlue")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
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
    
    func setupMainMenu() {
        setupSortingCategoryMenu()
        setupSortByMenu()
        setupSortMenu()
        
        setupFilterCategoryMenu()
        setupFilterByMenu()
        setupFilterMenu()
        
        mainMenu = UIMenu(options: .displayInline, children: [sortMenu, filterMenu])
    }
    
    func setupSortMenu() {
        sortMenu = UIMenu(title: "Сортировка", options: .singleSelection, children: [sortingCategoryMenu, sortByMenu])
    }
    
    func setupSortingCategoryMenu() {
        let menuItems: [UIMenuElement] = SortingCategory.allCases.map { category in
            UIAction(title: category.rawValue, image: nil, identifier: nil, handler: { _ in
                // Handle the selected item (update sortByMenu)
                print("Selected Item: \(category.rawValue)")
            })
        }
        
        sortingCategoryMenu = UIMenu(options: .displayInline, children: menuItems)
    }
    
    func setupSortByMenu() {
        let menuItems: [UIMenuElement] = []  // its dynamic
        
        sortByMenu = UIMenu(options: .displayInline, children: menuItems)
    }
    
    func setupFilterMenu() {
        filterMenu = UIMenu(title: "Фильтр", options: .singleSelection, children: [filterCategoryMenu, filterByMenu])
    }
    
    func setupFilterCategoryMenu() {
        let menuItems: [UIMenuElement] = FilterCategory.allCases.map { category in
            UIAction(title: category.rawValue, image: nil, identifier: nil, handler: { _ in
                // Handle the selected item (update sortByMenu)
                print("Selected Item: \(category.rawValue)")
            })
        }
        
        filterCategoryMenu = UIMenu(options: .displayInline, children: menuItems)
    }
    
    func setupFilterByMenu() {
        let menuItems: [UIMenuElement] = []  // its dynamic
        
        filterByMenu = UIMenu(options: .displayInline, children: menuItems)
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

extension TasksVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Done") { _, _, comletion in
            comletion(true)
        }
        action.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, comletion in
            tableView.deleteRows(at: [indexPath], with: .automatic)
            comletion(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
}

extension TasksVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? TasksTableViewCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.section]
        
        cell.startTimeLabel.text = task.startTime.convertToHoursMinutesFormat()
        cell.endTimeLabel.text = task.endTime.convertToHoursMinutesFormat()
        cell.taskNameLabel.text = task.taskName
        
        let priority = Priority(rawValue: task.taskTag) ?? Priority.none
        
//        cell.taskTagLabel.text = priority.convertToString()
//        cell.taskTagLabel.textColor = priority.convertToUIColor()
        cell.layer.borderColor = priority.convertToUIColor().cgColor
        
        let emptyView = UIView()
        emptyView.backgroundColor = .brandSecondary
        emptyView.layer.cornerRadius = 10
        cell.selectedBackgroundView = emptyView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
}

extension TasksVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }
}

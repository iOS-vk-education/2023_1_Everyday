//
//  TasksVC.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit
import Firebase

final class TasksVC: UIViewController {
    
    // MARK: - Private Properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let addTaskButton = UIButton(type: .system)
    
    private var mainMenu = UIMenu()
    private var sortMenu = UIMenu()
    private var filterMenu = UIMenu()
    private var sortingCategoryMenu = UIMenu()
    private var filterCategoryMenu = UIMenu()
    private var sortByMenu = UIMenu()
    private var filterByMenu = UIMenu()
    
    var tasks: [Task] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAddTaskButton()
        configureTableView()
        setupMainMenu()
        configureSearchController()
        configureViewController()
        layoutUI()
        getTasks()
    }
    
    // MARK: - Network
    
    func getTasks() {
        let group = DispatchGroup()
        TaskService.shared.fetchUserData { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let user):
                for taskReference in user.taskUID {
                    group.enter()
                    taskReference.getDocument { document, error in
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
                        
                        self.tasks.append(.init(startTime: startTime, endTime: endTime, taskName: taskName, taskPriority: taskTag))
                    }
                }
                group.notify(queue: .main) {
                    self.tasks.sort { $0.startTime < $1.startTime }
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    // MARK: - Configure UI Elements
    
    private func configureViewController() {
        view.backgroundColor = .brandPrimary
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        searchButton.tintColor = .brandSecondary

        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), menu: mainMenu)
        moreButton.tintColor = .brandSecondary
        
        navigationItem.rightBarButtonItems = [moreButton, searchButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dateLabel())
        
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureSearchController() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введите название задачи"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
    }
    
    private func dateLabel() -> UILabel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        let currentDate = dateFormatter.string(from: Date())
        
        let dateLabel = UILabel()
        dateLabel.text = currentDate.capitalized
        dateLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        dateLabel.textColor = .brandSecondary
        
        return dateLabel
    }
    
    private func configureAddTaskButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 60)  // wtf?
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        
        addTaskButton.setImage(image, for: .normal)
        addTaskButton.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        addTaskButton.tintColor = .brandSecondary
        addTaskButton.backgroundColor = .white
        addTaskButton.layer.cornerRadius = 55
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addTaskButton)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: TasksTableViewCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = .brandPrimary
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
    }
    
    // MARK: - Layout UI
    
    private func layoutUI() {
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
    
    // MARK: - Menu
    
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
    
    // MARK: - Button Actions
    
    @objc
    private func searchButtonTapped() {
        navigationItem.searchController = searchController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    @objc
    private func addTaskButtonTapped() {
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

// MARK: - Extensions

extension TasksVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Done") { _, _, completion in
            completion(true)
        }
        action.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
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
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TasksTableViewCell.reuseID, for: indexPath) as? TasksTableViewCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.section]
        
        cell.startTimeLabel.text = task.startTime.convertToHoursMinutesFormat()
        cell.endTimeLabel.text = task.endTime.convertToHoursMinutesFormat()
        cell.taskNameLabel.text = task.taskName
        
        let priority = Priority(rawValue: task.taskPriority) ?? Priority.none
        cell.layer.borderColor = priority.convertToUIColor().cgColor
        
        let emptyView = UIView()
        emptyView.backgroundColor = .brandSecondary
        emptyView.layer.cornerRadius = 10
        cell.selectedBackgroundView = emptyView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tasks.count
    }
}

extension TasksVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController = nil
    }
}

extension TasksVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // write code
    }
}

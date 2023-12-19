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
    var filteredTasks: [Task] = []
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        setupMainMenu()
        configureSearchController()
        configureAddTaskButton()
        configureViewController()
        layoutUI()
        getTasks()
    }
    
    // MARK: - Network
    
    func getTasks() {
        TaskService.shared.getTasks { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let tasks):
                self.tasks.append(contentsOf: tasks)
                self.tasks.sort { $0.startTime < $1.startTime }
                self.tableView.reloadData()
                
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
    
    // MARK: - Useful functions
    
    func filterContentForSearchText(_ searchText: String) {
        filteredTasks = tasks.filter { (task: Task) -> Bool in
            return task.taskName.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}

// MARK: - Extensions

extension TasksVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, completion in
            completion(true)
        }
        
        doneAction.image = UIImage(systemName: "checkmark")
        doneAction.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            TaskService.shared.updateWith(task: self.tasks[indexPath.section], actionType: .remove) { [weak self] error in
                guard let self = self else {
                    completion(false)
                    return
                }

                guard let error = error else {
                    self.tasks.remove(at: indexPath.section)
                    let indexSet: IndexSet = [indexPath.section]
                    tableView.deleteSections(indexSet, with: .fade)
                    
                    completion(true)
                    return
                }
                // present alert
                completion(true)
            }
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
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
        let task: Task
        
        if isFiltering {
            task = filteredTasks[indexPath.section]
        } else {
            task = tasks[indexPath.section]
        }
        
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
        if isFiltering {
            return filteredTasks.count
        }
        
        return tasks.count
    }
}

extension TasksVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController = nil
    }
}

extension TasksVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        filterContentForSearchText(searchText)
    }
}

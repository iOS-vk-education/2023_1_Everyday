//
//  TagVC.swift
//  Everyday
//
//  Created by Михаил on 27.12.2023.
//

import UIKit

class TagVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - private properties

    private var categories = TagModel(
        tag: []
    )
    private let addTagView = AddTagView()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor(named: "EverydayOrange")
        return button
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .close)
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TagService.shared.fetchTag { [weak self] user, error in
            guard let self = self else {
                return
            }
            if let error = error {
                AlertManager.showFetchingUserError(on: self, with: error)
                return
            }
            
            if let user = user {
                categories.tag.append(contentsOf: user.tag)
                self.tableView.reloadData()
            }
        }
        view.backgroundColor = UIColor(named: "EverydayBlue")

        setupUI()
    }
    // MARK: - Lifecycle
    private func setupUI() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "EverydayBlue")
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 12
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])

        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.tag.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories.tag[indexPath.row]
        cell.backgroundColor = UIColor(named: "EverydayLightBlue")
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories.tag[indexPath.row]
        handleSelectedCategory(selectedCategory)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let lastRow = tableView.numberOfRows(inSection: indexPath.section) - 1

            if indexPath.row == lastRow {
                cell.clipsToBounds = true
                cell.layer.cornerRadius = 12
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                cell.clipsToBounds = false
                cell.layer.cornerRadius = 0
                cell.layer.maskedCorners = []
            }
        }

    private func handleSelectedCategory(_ category: String) {
        // Обработка выбора категории
        // Например, вы можете передать выбранную категорию в другой метод или делегировать ее обработку
        print("Обработка выбранной категории: \(category)")

        dismiss(animated: true, completion: nil)
    }

    // MARK: - Actions

    @objc private func didTapAddButton() {
        print("Нажата кнопка '+'")
    }

    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

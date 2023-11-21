//
//  TasksVC.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit

final class TasksVC: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "Loading..."
        label.numberOfLines = 2
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        TaskService.shared.fetchUser { [weak self] user, error in
            guard let self = self else {
                return
            }
            if let error = error {
                AlertManager.showFetchingUserError(on: self, with: error)
                return
            }
            if let user = user {
                self.label.text = "\(user.username)\n\(user.email)"
            }
        }
        
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

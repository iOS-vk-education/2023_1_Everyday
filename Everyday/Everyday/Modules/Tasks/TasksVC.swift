//
//  TasksVC.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit

final class TasksVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        TaskService.shared.fetchUser { [weak self] _, error in
            guard let self = self else {
                return
            }
            if let error = error {
                AlertManager.showFetchingUserError(on: self, with: error)
                return
            }
        }
    }
}

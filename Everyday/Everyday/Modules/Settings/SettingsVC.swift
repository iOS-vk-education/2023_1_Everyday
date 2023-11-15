//
//  SettingsVC.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit

final class SettingsVC: UIViewController {
    
    // MARK: - Private properties
    
    private let logOutButton = UIButton()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "EverydayBlue")
       
        setupUI()
        
        view.addSubviews(logOutButton)
        
        setupConstraints()
    }
    // MARK: - Setup
    
    private func setupUI() {
        logOutButton.backgroundColor = UIColor(named: "EverydayOrange")
        logOutButton.setTitle("Выйти", for: .normal)
        logOutButton.addTarget(self, action: #selector(didTapLogOutButton), for: .touchUpInside)
        
        logOutButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        logOutButton.setTitleColor(.black, for: .normal)
        logOutButton.layer.cornerRadius = 5
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        }
    
    // MARK: - Layout
    
    private func setupConstraints() {
        logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0.1 * view.bounds.height).isActive = true
        logOutButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
        logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // MARK: - Actions

    @objc
    private func didTapLogOutButton() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else {
                return
            }
            if let error = error {
                AlertManager.showLogoutError(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
}

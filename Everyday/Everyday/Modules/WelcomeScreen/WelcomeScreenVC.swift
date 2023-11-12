//
//  AuthScreenVC.swift
//  Everyday
//
//  Created by Михаил on 06.11.2023.
//

import UIKit

final class WelcomeScreenVC: UIViewController {
    
    // MARK: - Private properties
    
    private let logoImageView = UIImageView()
    private let semiBoldLabel = UILabel()
    private let boldLabel = UILabel()
    private let signUpButton = UIButton()
    private let logInButton = UIButton()
    private var textStackView = UIStackView()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "EverydayBlue")
        
        setupUI()
        
        view.addSubviews(logoImageView, textStackView, signUpButton, logInButton)
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    // MARK: - Setup
    
    private func setupUI() {
        setupLogoImage()
        setupLabels()
        setupActiveButtons()
        setupTextStackView()
    }
    
    private func setupLogoImage() {
        logoImageView.image = UIImage(named: "logo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLabels() {
        semiBoldLabel.text = "Планируй, Действуй, "
        semiBoldLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        semiBoldLabel.textColor = UIColor(named: "EverydayOrange")
        
        boldLabel.text = "Everyday"
        boldLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
        boldLabel.textColor = UIColor(named: "EverydayOrange")
    }
    
    private func setupActiveButtons() {
        logInButton.backgroundColor = UIColor(named: "EverydayOrange")
        logInButton.setTitle("Войти", for: .normal)
        logInButton.addTarget(self, action: #selector(didTapLogInButton), for: .touchUpInside)
        
        signUpButton.backgroundColor = .white
        signUpButton.setTitle("Создать аккаунт", for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
        [logInButton, signUpButton].forEach { button in
            button.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 5
            button.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupTextStackView() {
        textStackView.spacing = 1
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.addArrangedSubview(semiBoldLabel)
        textStackView.addArrangedSubview(boldLabel)
    }
    
    // MARK: - Layout
    
    private func setupConstraints() {
        logoImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.75).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.75).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -0.18 * view.bounds.height).isActive = true
        
        logInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0.1 * view.bounds.height).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0.17 * view.bounds.height).isActive = true
        
        [logInButton, signUpButton].forEach { button in
            button.widthAnchor.constraint(equalTo: textStackView.widthAnchor).isActive = true
            button.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        
        textStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: view.bounds.width * 0.02).isActive = true
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapSignUpButton() {
        let signupVC = SignUpVC()
        
        signupVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @objc
    private func didTapLogInButton() {
        let loginVC = LoginVC()
        
        loginVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(loginVC, animated: true)
    }
}

//  RegisterVC.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit

final class SignUpVC: UIViewController {

    // MARK: - Private properties
    
    private let signUpLabel = UILabel()
    private let logInLabel = UILabel()
    private let signUpButton = UIButton()
    private let logInButton = UIButton(type: .custom)
    private let emailField = UITextField()
    private let usernameField = UITextField()
    private let passwordField = UITextField()
    private let repPasswordField = UITextField()
    private let logInLabelButtonStackView = UIStackView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "EverydayBlue")
    
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapWholeView))
        view.addGestureRecognizer(gestureRecognizer)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
        navigationItem.rightBarButtonItem = closeButton
        
        setupUI()
        
        view.addSubviews(scrollView)
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    // MARK: - Setup
    
    private func setupUI() {
        setupScrollView()
        setupContentView()
        setupLabels()
        setupButtons()
        setupTextFieldsView()
        setupStackView()
    }
        
    private func setupScrollView() {
            scrollView.addSubview(contentView)
            
            scrollView.showsVerticalScrollIndicator = false
            scrollView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        private func setupContentView() {
            contentView.addSubviews(signUpLabel, emailField, usernameField, passwordField,
                                    repPasswordField, signUpButton, logInLabelButtonStackView)
            
            contentView.translatesAutoresizingMaskIntoConstraints = false
        }
    
    private func setupLabels() {
        signUpLabel.text = "Регистрация"
        signUpLabel.font = UIFont(name: "Montserrat-Bold", size: 28)
        signUpLabel.textColor = .white
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        logInLabel.text = "Уже есть аккаунт ?"
        logInLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        logInLabel.textColor = .gray
    }
    
    private func setupButtons() {
        let loginAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "EverydayOrange") ?? .orange,
            .font: UIFont(name: "Montserrat-SemiBold", size: 14.0) ?? .systemFont(ofSize: 14)
        ]
        let loginAttributedString = NSAttributedString(string: "Войти", attributes: loginAttributes)
        
        logInButton.setAttributedTitle(loginAttributedString, for: .normal)
        logInButton.addTarget(self, action: #selector(didTapLogInButton), for: .touchUpInside)
        
        signUpButton.backgroundColor = UIColor(named: "EverydayOrange")
        signUpButton.setTitle("Создать аккаунт", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.layer.cornerRadius = 5
        signUpButton.addTarget(self, action: #selector(didTapsignUpButtonButton), for: .touchUpInside)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupStackView() {
        logInLabelButtonStackView.spacing = 10
        logInLabelButtonStackView.addArrangedSubview(logInLabel)
        logInLabelButtonStackView.addArrangedSubview(logInButton)
        
        logInLabelButtonStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTextFieldsView() {
        emailField.attributedPlaceholder = NSAttributedString(string: "Email")
        usernameField.attributedPlaceholder = NSAttributedString(string: "Имя пользователя")
        passwordField.attributedPlaceholder = NSAttributedString(string: "Пароль")
        repPasswordField.attributedPlaceholder = NSAttributedString(string: "Повторите пароль")
        
        passwordField.isSecureTextEntry = true
        repPasswordField.isSecureTextEntry = true
        
        [emailField, usernameField, passwordField, repPasswordField].forEach { field in
            field.autocorrectionType = .no
            field.autocapitalizationType = .none
            field.backgroundColor = .white
            field.font = UIFont(name: "Montserrat-SemiBold", size: 14)
            field.textColor = .black
            field.layer.cornerRadius = 5
            field.attributedPlaceholder = NSAttributedString(
                    string: field.placeholder ?? "",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
                )
            field.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    // MARK: - Layout
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            signUpLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.083 * view.bounds.height),
            signUpLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                       
            emailField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.23 * view.bounds.height),
            usernameField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.31 * view.bounds.height),
            passwordField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.39 * view.bounds.height),
            repPasswordField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.47 * view.bounds.height),
                       
            signUpButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.55 * view.bounds.height),
                       
            logInLabelButtonStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logInLabelButtonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
                   
        [emailField, usernameField, passwordField, repPasswordField, signUpButton].forEach { element in
         element.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.75).isActive = true
         element.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
         element.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapCloseButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapsignUpButtonButton() {
        let registerUserRequest = SignUpRequest(
            username: self.usernameField.text ?? "",
            email: self.emailField.text ?? "",
            password: self.passwordField.text ?? ""
        )
    
        if !Validator.isValidUsername(for: registerUserRequest.username) {
            AlertManager.showInvalidUsernameAlert(on: self)
            return
        }
        
        if !Validator.isValidEmail(for: registerUserRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        if !Validator.isPasswordValid(for: registerUserRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                AlertManager.showRegistrationErrorAlert(on: self, with: error)
                return
            }
            
            if wasRegistered {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            } else {
                AlertManager.showRegistrationErrorAlert(on: self)
            }
        }
    }
    
    @objc
    private func didTapLogInButton() {
        let loginVC = LoginVC()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    // MARK: - Keyboard Actions
    @objc
    func keyboardWillShow(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrameInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        
        let keyboardHeight = keyboardFrameInfo.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight
    }

    @objc
    func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
    
    @objc
    func didTapWholeView() {
        view.endEditing(true)
    }
    
    // MARK: - Swipe Actions
    @objc
    func swipeFunc(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            navigationController?.popViewController(animated: true)
        }
    }
}

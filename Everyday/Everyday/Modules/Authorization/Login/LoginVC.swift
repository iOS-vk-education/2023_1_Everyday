//
//  LoginVC.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit

final class LoginVC: UIViewController {
    
    // MARK: - Private properties
    
    private let logInLabel = UILabel()
    private let signUpLabel = UILabel()
    private let signUpButton = UIButton(type: .custom)
    private let logInButton = UIButton()
    private let showPasswordButton = UIButton(type: .custom)
    private let forgotPasswordButton = UIButton(type: .custom)
    private let emailOrUsernameField = UITextField()
    private let passwordField = UITextField()
    private let signUpLabelButtonStackView = UIStackView()
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
        contentView.addSubviews(logInLabel, emailOrUsernameField, passwordField,
                                logInButton, forgotPasswordButton, signUpLabelButtonStackView, showPasswordButton)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLabels() {
        logInLabel.text = "Вход"
        logInLabel.font = UIFont(name: "Montserrat-Bold", size: 28)
        logInLabel.textColor = .white
        logInLabel.translatesAutoresizingMaskIntoConstraints = false
        
        signUpLabel.text = "Не зарегистрированы ?"
        signUpLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        signUpLabel.textColor = .gray
    }
    
    private func setupButtons() {
        logInButton.backgroundColor = UIColor(named: "EverydayOrange")
        logInButton.setTitle("Войти", for: .normal)
        logInButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        logInButton.setTitleColor(.black, for: .normal)
        logInButton.layer.cornerRadius = 5
        logInButton.addTarget(self, action: #selector(didTapLogInButton), for: .touchUpInside)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "EverydayOrange") ?? .orange,
            .font: UIFont(name: "Montserrat-SemiBold", size: 14.0) ?? .systemFont(ofSize: 14)
        ]
        let signupAttributedString = NSAttributedString(string: "Регистрация", attributes: attributes)
        
        signUpButton.setAttributedTitle(signupAttributedString, for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapsignUpButton), for: .touchUpInside)
        
        let forgotPasswordAttributesAttributedString = NSAttributedString(string: "Не можешь войти ?", attributes: attributes)
        
        forgotPasswordButton.setAttributedTitle(forgotPasswordAttributesAttributedString, for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPasswordButton), for: .touchUpInside)
        
        showPasswordButton.contentMode = .scaleAspectFill
        showPasswordButton.setImage(UIImage(named: "no_eye"), for: .normal)
        showPasswordButton.setImage(UIImage(named: "eye"), for: .selected)
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTextFieldsView() {
        emailOrUsernameField.attributedPlaceholder = NSAttributedString(string: "Email или Имя пользователя")
        
        passwordField.attributedPlaceholder = NSAttributedString(string: "Пароль")
        passwordField.isSecureTextEntry = true
        passwordField.rightView = showPasswordButton
        passwordField.rightViewMode = .always
        
        [emailOrUsernameField, passwordField].forEach { field in
            field.backgroundColor = .white
            field.font = UIFont(name: "Montserrat-SemiBold", size: 16)
            field.textColor = .black
            field.layer.cornerRadius = 5
            field.attributedPlaceholder = NSAttributedString(
                    string: field.placeholder ?? "",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
                )
            field.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupStackView() {
        signUpLabelButtonStackView.spacing = 10
        signUpLabelButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        signUpLabelButtonStackView.addArrangedSubview(signUpLabel)
        signUpLabelButtonStackView.addArrangedSubview(signUpButton)
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
            
            logInLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.063 * view.bounds.height),
            logInLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            emailOrUsernameField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.31 * view.bounds.height),
            passwordField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.39 * view.bounds.height),
            
            logInButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.47 * view.bounds.height),
            
            forgotPasswordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            forgotPasswordButton.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.77 * view.bounds.height),
            
            showPasswordButton.widthAnchor.constraint(equalTo: passwordField.widthAnchor, constant: 0.16 * contentView.bounds.width),
            showPasswordButton.heightAnchor.constraint(equalTo: passwordField.heightAnchor),
            showPasswordButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: -0.08 * contentView.bounds.width),
            showPasswordButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor),
            
            signUpLabelButtonStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signUpLabelButtonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        [emailOrUsernameField, passwordField, logInButton].forEach { element in
            element.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.75).isActive = true
            element.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
            element.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapLogInButton() {
        let loginRequest = LoginModel(
            email: self.emailOrUsernameField.text ?? "",
            password: self.passwordField.text ?? ""
        )
        
        if !Validator.isValidEmail(for: loginRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        AuthService.shared.logIn(with: loginRequest) { error in
            if let error = error {
                AlertManager.showSignInErrorAlert(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
    
    @objc func togglePasswordVisibility() {
        passwordField.isSecureTextEntry.toggle()
        let isOpen = !passwordField.isSecureTextEntry
        (passwordField.rightView as? UIButton)?.isSelected = isOpen
    }
    
    @objc
    private func didTapCloseButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapsignUpButton() {
        let signupVC = SignUpVC()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @objc
    private func didTapForgotPasswordButton() {
        let forgotPasswordVC = ForgotPasswordVC()
        navigationController?.pushViewController(forgotPasswordVC, animated: true)
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
        
        let keyBoardHeight = keyboardFrameInfo.cgRectValue.height
        scrollView.contentInset.bottom = keyBoardHeight
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

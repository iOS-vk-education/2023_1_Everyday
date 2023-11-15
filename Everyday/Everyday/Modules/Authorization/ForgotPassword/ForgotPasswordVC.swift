//
//  ForgotPasswordVC.swift
//  Everyday
//
//  Created by Михаил on 15.11.2023.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    // MARK: - Private properties
    
    private let headerLabel = UILabel()
    private let resetLabel = UILabel()
    private let emailField = UITextField()
    private let signUpButton = UIButton()
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
    }
    
    private func setupScrollView() {
            scrollView.addSubview(contentView)
            
            scrollView.showsVerticalScrollIndicator = false
            scrollView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        private func setupContentView() {
            contentView.addSubviews(headerLabel, resetLabel, emailField, signUpButton)
            
            contentView.translatesAutoresizingMaskIntoConstraints = false
        }
    
    private func setupLabels() {
        headerLabel.text = "Забыли пароль ?"
        headerLabel.font = UIFont(name: "Montserrat-Bold", size: 28)
        headerLabel.textColor = .white
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        resetLabel.text = "Сбросить пароль"
        resetLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        resetLabel.textColor = .gray
        
        resetLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupButtons() {
        signUpButton.backgroundColor = UIColor(named: "EverydayOrange")
        signUpButton.setTitle("Создать аккаунт", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.layer.cornerRadius = 5
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTextFieldsView() {
        emailField.attributedPlaceholder = NSAttributedString(string: "Email")
        emailField.backgroundColor = .white
        emailField.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        emailField.textColor = .black
        emailField.layer.cornerRadius = 5
        emailField.attributedPlaceholder = NSAttributedString(
                    string: emailField.placeholder ?? "",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
                )
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
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
            
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.083 * view.bounds.height),
            headerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            resetLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.16 * view.bounds.height),
            resetLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                       
            emailField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.23 * view.bounds.height),
            signUpButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.31 * view.bounds.height)
        ])
                   
        [emailField, signUpButton].forEach { element in
         element.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.75).isActive = true
         element.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
         element.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapSignUpButton() {
        let email = self.emailField.text ?? ""
        
        if !Validator.isValidEmail(for: email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        AuthService.shared.forgotPassword(with: email) { [weak self] error in
            guard let self = self else {
                return
            }
            if let error = error {
                AlertManager.showErrorSendingPasswordReset(on: self, with: error)
                return
            }
            
            AlertManager.showPasswordResetSent(on: self)
        }
    }
    
    @objc
    private func didTapCloseButton() {
        navigationController?.popViewController(animated: true)
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

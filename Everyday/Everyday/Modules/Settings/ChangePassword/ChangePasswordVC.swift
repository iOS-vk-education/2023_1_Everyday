//
//  ChangePasswordVC.swift
//  Everyday
//
//  Created by Yaz on 19.11.2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

final class ChangePasswordVC: UIViewController {
    
    // MARK: - Private properties
    
    private let oldPasswordField = UITextField()
    private let newPasswordField = UITextField()
    private let repeatNewPasswordField = UITextField()
    private let passwordsStackView = UIStackView()
    private let confirmButton = UIButton()
    private let forgotPasswordButton = UIButton(type: .custom)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    var uid: String = " "
    
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
        
        setupConstrains()
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
        setupStackView()
        setupFields()
        setupButtons()
    }
    
    private func setupScrollView() {
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupContentView() {
        contentView.addSubviews(oldPasswordField, newPasswordField, repeatNewPasswordField,
                                confirmButton, forgotPasswordButton, passwordsStackView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupStackView() {
        passwordsStackView.spacing = 10
        passwordsStackView.axis = .vertical
        passwordsStackView.distribution = .equalSpacing
        passwordsStackView.addArrangedSubview(oldPasswordField)
        passwordsStackView.addArrangedSubview(newPasswordField)
        passwordsStackView.addArrangedSubview(repeatNewPasswordField)
        passwordsStackView.addArrangedSubview(confirmButton)
        
        passwordsStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFields() {
        oldPasswordField.attributedPlaceholder = NSAttributedString(string: "Текущий пароль")
        newPasswordField.attributedPlaceholder = NSAttributedString(string: "Новый пароль")
        repeatNewPasswordField.attributedPlaceholder = NSAttributedString(string: "Подтвердите новый пароль")
        
        [oldPasswordField, newPasswordField, repeatNewPasswordField].forEach { field in
            field.backgroundColor = .white
            field.font = UIFont(name: "Montserrat-SemiBold", size: 14)
            field.textColor = .black
            field.layer.cornerRadius = 5
            field.attributedPlaceholder = NSAttributedString(
                    string: field.placeholder ?? "",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
                )
            field.textAlignment = .left
            field.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupButtons() {
        confirmButton.backgroundColor = UIColor(named: "EverydayOrange")
        confirmButton.setTitle("Изменить", for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 5
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "EverydayOrange") ?? .orange,
            .font: UIFont(name: "Montserrat-SemiBold", size: 14.0) ?? .systemFont(ofSize: 14)
        ]
        
        let forgotPasswordAttributesAttributedString = NSAttributedString(string: "Забыли пароль ?", attributes: attributes)
        forgotPasswordButton.setAttributedTitle(forgotPasswordAttributesAttributedString, for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPasswordButton), for: .touchUpInside)
        
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Layout
    
    private func setupConstrains() {
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
            
            passwordsStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            passwordsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            oldPasswordField.topAnchor.constraint(equalTo: passwordsStackView.topAnchor),
            newPasswordField.topAnchor.constraint(equalTo: passwordsStackView.topAnchor, constant: 0.08 * view.bounds.height),
            repeatNewPasswordField.topAnchor.constraint(equalTo: passwordsStackView.topAnchor, constant: 0.16 * view.bounds.height),
            confirmButton.topAnchor.constraint(equalTo: passwordsStackView.topAnchor, constant: 0.24 * view.bounds.height),
            
            forgotPasswordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            forgotPasswordButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        [oldPasswordField, newPasswordField, repeatNewPasswordField, confirmButton].forEach { element in
            element.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.75).isActive = true
            element.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapForgotPasswordButton() {
        let forgotPasswordVC = ForgotPasswordVC()
        navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    @objc
    private func didTapCloseButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapConfirmButton() {
        let validationErrors = Validator.validatePassword(for: newPasswordField.text ?? "")
        
        if !validationErrors.isEmpty {
            let errorMessage = validationErrors.joined(separator: "\n")
            AlertManager.showInvalidPasswordAlert(on: self, message: errorMessage)
        }
        
        if newPasswordField.text == repeatNewPasswordField.text {
            let password = oldPasswordField.text ?? ""
            let currentUser = Auth.auth().currentUser
            let email = Auth.auth().currentUser?.email ?? ""
            let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email,
                                                                          password: password
            )
            currentUser?.reauthenticate(with: credential) {_, error  in
                if let error = error {
                    print(error)
                }
            }
            
            Auth.auth().signIn(withEmail: Auth.auth().currentUser?.email ?? "", password: oldPasswordField.text ?? "") { [weak self] _, error in
                if let error = error {
                    print(error)
                    return
                }
                currentUser?.updatePassword(to: self?.newPasswordField.text ?? "") { error in
                    if let error = error {
                        print(error)
                        return
                    }
                }
            }
        }
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

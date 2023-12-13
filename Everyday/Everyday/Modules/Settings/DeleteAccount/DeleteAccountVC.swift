//
//  DeleteAccountVC.swift
//  Everyday
//
//  Created by Yaz on 23.11.2023.
//

//
//  ChangePasswordVC.swift
//  Everyday
//
//  Created by Yaz on 19.11.2023.
//

import UIKit

final class DeleteAccountVC: UIViewController {
    
    // MARK: - Private properties
    
    private let confirmEmailField = UITextField()
    private let confirmPasswordField = UITextField()
    private let confirmStackView = UIStackView()
    private let confirmButton = UIButton()
    private let forgotPasswordButton = UIButton(type: .custom)
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
        contentView.addSubviews(confirmEmailField, confirmPasswordField,
                                confirmButton, forgotPasswordButton, confirmStackView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupStackView() {
        confirmStackView.spacing = 10
        confirmStackView.axis = .vertical
        confirmStackView.distribution = .equalSpacing
        confirmStackView.addArrangedSubview(confirmEmailField)
        confirmStackView.addArrangedSubview(confirmPasswordField)
        confirmStackView.addArrangedSubview(confirmButton)
        
        confirmStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFields() {
        confirmEmailField.attributedPlaceholder = NSAttributedString(string: "Подтвердите Email")
        confirmPasswordField.attributedPlaceholder = NSAttributedString(string: "Подтвердите пароль")
        
        [confirmEmailField, confirmPasswordField].forEach { field in
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
        confirmButton.setTitle("Удалить", for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 5
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
            
            confirmStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            confirmStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            confirmEmailField.topAnchor.constraint(equalTo: confirmStackView.topAnchor),
            confirmPasswordField.topAnchor.constraint(equalTo: confirmStackView.topAnchor, constant: 0.08 * view.bounds.height),
            confirmButton.topAnchor.constraint(equalTo: confirmStackView.topAnchor, constant: 0.16 * view.bounds.height),
            
            forgotPasswordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            forgotPasswordButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        [confirmEmailField, confirmPasswordField, confirmButton].forEach { element in
            element.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.75).isActive = true
            element.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
//            element.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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

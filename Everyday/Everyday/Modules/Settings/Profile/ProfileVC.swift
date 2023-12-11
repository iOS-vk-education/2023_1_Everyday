//
//  ProfileVC.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit

final class ProfileVC: UIViewController {
    
    // MARK: - Private properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let userImage = UIImageView()
    private let changeUserImageButton = UIButton()
    private let deleteAccountButton = UIButton()
    private let userNameTableView = UITableView()
    private let changeTableView = UITableView()
    private let userNameCell = userNameCellModel(textFieldText: "Артур Сардарян", name: "Имя: ")
    private let changeOrExitCell = [changeOrExitCellModel(titleText: "Изменить Email"),
                                changeOrExitCellModel(titleText: "Изменить пароль"),
                                changeOrExitCellModel(titleText: "Выйти")]
    private let pencil = UIImageView()
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
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
        navigationItem.rightBarButtonItem = closeButton
        
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(didTapSaveButton))
        saveButton.tintColor = .brandSecondary
        navigationItem.leftBarButtonItem = saveButton
        
        changeTableView.dataSource = self
        changeTableView.delegate = self
        changeTableView.register(ChangeOrExitTableViewCell.self, forCellReuseIdentifier: "changeCell")
        
        userNameTableView.dataSource = self
        userNameTableView.delegate = self
        userNameTableView.register(UserNameTableViewCell.self, forCellReuseIdentifier: "fieldCell")
        
        setupUI()
        
        view.addSubviews(scrollView, changeTableView)
        
        setupConstrains()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setupUI() {
        setupScrollView()
        setupTableView()
        setupContentView()
        setupImage()
        setupButtons()
    }
    
    private func setupTableView() {
        changeTableView.backgroundColor = .brandPrimaryLight
        changeTableView.layer.cornerRadius = 10
        changeTableView.separatorColor = .brandPrimary
        changeTableView.isScrollEnabled = false
        changeTableView.translatesAutoresizingMaskIntoConstraints = false
        
        userNameTableView.backgroundColor = .brandPrimaryLight
        userNameTableView.layer.cornerRadius = 10
        userNameTableView.separatorColor = .brandPrimary
        userNameTableView.isScrollEnabled = false
        userNameTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setupScrollView() {
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupContentView() {
        contentView.addSubviews(userImage, changeUserImageButton, deleteAccountButton, userNameTableView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupImage() {
        userImage.image = UIImage(named: "logo")
        userImage.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.5 / 2
        userImage.clipsToBounds = true
        userImage.translatesAutoresizingMaskIntoConstraints = false
        
        let cellImageConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20))
        pencil.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        pencil.image = UIImage(systemName: "pencil.circle", withConfiguration: cellImageConfiguration)
        pencil.tintColor = .lightGray
    }
    
    private func setupButtons() {
        deleteAccountButton.setTitle("Удалить аккаунт ?", for: .normal)
        deleteAccountButton.setTitleColor(.red, for: .normal)
        deleteAccountButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        deleteAccountButton.addTarget(self, action: #selector(didTapDeleteAccountButton), for: .touchUpInside)
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        changeUserImageButton.setTitle("Выбрать фотографию", for: .normal)
        changeUserImageButton.setTitleColor(.brandSecondary, for: .normal)
        changeUserImageButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        changeUserImageButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
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
            
            userNameTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            userNameTableView.topAnchor.constraint(equalTo: changeUserImageButton.bottomAnchor, constant: 30),
            userNameTableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.8),
            userNameTableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height * 0.05),
            
            changeTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            changeTableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.8),
            changeTableView.topAnchor.constraint(equalTo: userNameTableView.bottomAnchor, constant: 30),
            
            changeTableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height * 0.15),
            
            userImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            userImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            userImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.5),
            userImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.5),
            
            changeUserImageButton.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: contentView.bounds.height * 0.08),
            changeUserImageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                        
            deleteAccountButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            deleteAccountButton.topAnchor.constraint(equalTo: changeTableView.bottomAnchor, constant: UIScreen.main.bounds.size.height * 0.008)
        ])
    }
    
    // MARK: Actions
    
    @objc
    private func didTapDeleteAccountButton() {
        let deleteAccountVC = DeleteAccountVC()
        navigationController?.pushViewController(deleteAccountVC, animated: true)
    }
    
    @objc
    private func didTapSaveButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapChangeEmailCell() {
        let changeEmailVC = ChangeEmailVC()
        navigationController?.pushViewController(changeEmailVC, animated: true)
    }
    
    @objc
    private func didTapChangePasswordCell() {
        let changePasswordVC = ChangePasswordVC()
        navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
    @objc
    private func editingUserNameDidEnd() {
        pencil.tintColor = .lightGray
    }
        
    @objc
    func textFieldIsEditing() {
        pencil.tintColor = .brandSecondary
    }
    
    @objc
    private func didTapExitCell() {
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
    // MARK: - Keyboard Actions
    @objc
    private func didTapCloseButton() {
        navigationController?.popViewController(animated: true)
    }
    
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
        pencil.tintColor = .lightGray
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

extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == changeTableView {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == userNameTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "fieldCell", for: indexPath) as? UserNameTableViewCell {
                
                let cellTexts = userNameCell
                
                cell.cellLabel.text = cellTexts.name
                cell.cellTextField.text = cellTexts.textFieldText
                cell.cellTextField.addTarget(self, action: #selector(editingUserNameDidEnd), for: .editingDidEndOnExit)
                cell.cellTextField.addTarget(self, action: #selector(textFieldIsEditing), for: .editingDidBegin)
                
                cell.accessoryView = pencil
                cell.selectionStyle = .none
                cell.backgroundColor = .brandPrimaryLight
                
                return cell
            } else {
                let defaultCell = UITableViewCell()
                return defaultCell
            }
        }
        
        if tableView == changeTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "changeCell", for: indexPath) as? ChangeOrExitTableViewCell {
                let cellLabel = changeOrExitCell[indexPath.row]
                
                cell.accessoryType = .disclosureIndicator
                cell.cellLabel.text = cellLabel.titleText
                cell.backgroundColor = .brandPrimaryLight
                cell.selectionStyle = .none
                if indexPath.row == 2 {
                    cell.backgroundColor = .brandSecondary
                }
                
                return cell
            } else {
                let defaultCell = UITableViewCell()
                return defaultCell
            }
        }
        return UITableViewCell()
    }
}

extension ProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return view.bounds.height * 0.05
        } else {
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == changeTableView {
            switch indexPath.row {
            case 0: didTapChangeEmailCell()
            case 1: didTapChangePasswordCell()
            case 2: didTapExitCell()
            default:
                print("error")
            }
        }
    }
}

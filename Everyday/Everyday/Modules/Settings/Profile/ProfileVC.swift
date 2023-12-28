//
//  ProfileVC.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

final class ProfileVC: UIViewController {
    
    // MARK: - Private properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let userImage = UIImageView()
    private let changeUserImageButton = UIButton()
    private let deleteAccountButton = UIButton()
    private var username = String()
    private var avatarURL: String = ""
    
    var uid: String = " "
    
    private let changeTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        
        table.register(UserNameTableViewCell.self, forCellReuseIdentifier: "fieldCell")
        
        table.register(ChangeOrExitTableViewCell.self, forCellReuseIdentifier: "changeCell")
        
        return table
    }()
    
    private var usernameCellModel = userNameCellModel(fieldText: "", name: "Имя: ")
    private let changeOrExitCellModels = [changeOrExitCellModel(titleText: "Изменить Email"),
                                changeOrExitCellModel(titleText: "Изменить пароль"),
                                changeOrExitCellModel(titleText: "Выйти")]
    private let pencilImageView = UIImageView()
    
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
        
        SettingsService.shared.fetchUser { [weak self] userProfile, error in
            guard let self = self
            else {
                return
            }
            if let error = error {
                AlertManager.showFetchingUserError(on: self, with: error)
                return
            }
            
            if let userProfile = userProfile {
                usernameCellModel = userNameCellModel(fieldText: userProfile.username, name: "Имя: ")
                self.avatarURL = userProfile.avatarURL
                guard let userUID = Auth.auth().currentUser?.uid else {
                    return
                }
                uid = userUID
                downloadImage()
                changeTableView.reloadData()
            }
        }
        
        changeTableView.dataSource = self
        changeTableView.delegate = self
        
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
        changeTableView.backgroundColor = .none
        changeTableView.layer.cornerRadius = 10
        changeTableView.separatorColor = .brandPrimary
        changeTableView.isScrollEnabled = false
        changeTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setupScrollView() {
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupContentView() {
        contentView.addSubviews(userImage, changeUserImageButton, deleteAccountButton)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupImage() {
        userImage.image = UIImage(named: "artur")
        userImage.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.5 / 2
        userImage.clipsToBounds = true
        userImage.translatesAutoresizingMaskIntoConstraints = false
        
        let cellImageConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20))
        pencilImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        pencilImageView.image = UIImage(systemName: "pencil.circle", withConfiguration: cellImageConfiguration)
        pencilImageView.tintColor = .lightGray
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
        changeUserImageButton.addTarget(self, action: #selector(didTapChangePhotoButton), for: .touchUpInside)
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
            
            changeTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            changeTableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.8),
            changeTableView.topAnchor.constraint(equalTo: changeUserImageButton.bottomAnchor, constant: 30),
            
            changeTableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height * 0.3),
            
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
        didTapWholeView()
        SettingsService.shared.updateUsername(username: username)
        
        uploadImage(photo: userImage.image!) { result in
            switch result {
            case .success(let url):
                SettingsService.shared.updateAvatarUrl(url: url.absoluteString)
            case .failure(let error):
                print(error)
            }
        }
        
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
        pencilImageView.tintColor = .lightGray
    }
        
    @objc
    private func textFieldIsEditing() {
        pencilImageView.tintColor = .brandSecondary
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
    
    @objc
    private func didTapChangePhotoButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()

        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard Actions
    @objc
    private func didTapCloseButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
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
    private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
    
    @objc
    private func didTapWholeView() {
        pencilImageView.tintColor = .lightGray
        view.endEditing(true)
    }
    
    // MARK: - Swipe Actions
    
    @objc
    private func swipeFunc(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    private func downloadImage() {
        let reference = Storage.storage().reference(forURL: avatarURL)
            let megaByte = Int64(3 * 1024 * 1024)
        reference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                return
            }
            let image = UIImage(data: imageData)
            self.userImage.image = image
        }
    }
    
    private func uploadImage(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let reference = Storage.storage().reference().child("avatars").child(userUID)
        guard let imageData = userImage.image?.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        reference.putData(imageData, metadata: metadata) { (metadata, error) in
            guard let m = metadata else {
                return
            }
            reference.downloadURL { (url, error) in
                guard let url = url else {
                    return
                }
                completion(.success(url))
            }
        }
    }
}

// MARK: - Extensions

extension ProfileVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0, 0] {
            tableView.register(UserNameTableViewCell.self, forCellReuseIdentifier: "fieldCell")
            if let cell = tableView.dequeueReusableCell(withIdentifier: "fieldCell", for: indexPath) as? UserNameTableViewCell {
                
                let cellTexts = usernameCellModel
                
                cell.cellLabel.text = cellTexts.name
                cell.cellTextField.text = cellTexts.fieldText
                cell.cellTextField.addTarget(self, action: #selector(editingUserNameDidEnd), for: .editingDidEndOnExit)
                cell.cellTextField.delegate = self
                cell.cellTextField.delegate = self
                cell.cellTextField.addTarget(self, action: #selector(textFieldIsEditing), for: .editingDidBegin)
                
                cell.accessoryView = pencilImageView
                cell.selectionStyle = .none
                cell.backgroundColor = .brandPrimaryLight
                
                return cell
            } else {
                let defaultCell = UITableViewCell()
                return defaultCell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "changeCell", for: indexPath) as? ChangeOrExitTableViewCell {
                let cellLabel = changeOrExitCellModels[indexPath.row]
                
                cell.accessoryType = .disclosureIndicator
                cell.cellLabel.text = cellLabel.titleText
                cell.backgroundColor = .brandPrimaryLight
                if indexPath.row == 2 {
                    cell.backgroundColor = .brandSecondary
                }
                
                return cell
            } else {
                let defaultCell = UITableViewCell()
                return defaultCell
            }
        }
    }
}

extension ProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * 0.05
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0: didTapChangeEmailCell()
            case 1: didTapChangePasswordCell()
            case 2: didTapExitCell()
            default:
                print("fatalError")
            }
        }
    }
}

extension ProfileVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !Validator.isValidUsername(for: textField.text ?? "") {
            AlertManager.showInvalidUsernameAlert(on: self)
            username = usernameCellModel.fieldText
        } else {
            username = textField.text ?? ""
        }
    }
}

extension ProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey
                                                                                                       : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        userImage.image = image
    }
}

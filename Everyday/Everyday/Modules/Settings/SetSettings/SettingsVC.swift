//
//  SettingsVC.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

final class SettingsVC: UIViewController {
    
    private let changeImageBtnTableView = UITableView()
    private let userImage = UIImageView()
    private let userNameLabel = UILabel()
    private let userBlockStackView = UIStackView()
    private let contentView = UIView()
    private let editButtonTitle = UILabel()
    private var avatarURL: String = ""
    
    var uid: String = " "
    
    private let settingsTableView = UITableView(frame: .zero, style: .insetGrouped)
    private let changeImageTitleCellModel = SettingsTableViewCellModel(cellImageName: "camera.badge.ellipsis", cellTitle: "Изменить фото")
    private let aboutAppCellModels = [SettingsTableViewCellModel(cellImageName: "person.fill.questionmark", cellTitle: "Обратная связь"),
                                     SettingsTableViewCellModel(cellImageName: "newspaper.fill", cellTitle: "Блог"),
                                     SettingsTableViewCellModel(cellImageName: "book.fill", cellTitle: "FAQ")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "EverydayBlue")

        let editBtn = UIBarButtonItem(title: "Изм.", style: .plain, target: self, action: #selector(didTapEditButton))
        editBtn.tintColor = .brandSecondary
        navigationItem.rightBarButtonItem = editBtn
        
        navigationItem.title = nil
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "settingsCustomCell")

        setupUI()
        
        view.addSubviews(contentView)
        
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUsername()
    }
    
    // MARK: - Setup
    private func setupUI() {
        updateUsername()
        setupStackViews()
        setupContentView()
        setupUserImage()
        setupLabels()
        setupTableView()
    }
    
    func updateUsername() {
        SettingsService.shared.fetchUser { [weak self] userSettings, _ in
            guard let self = self
            else {
                return
            }

            if let userSettings = userSettings {
                userNameLabel.text = userSettings.username
                self.avatarURL = userSettings.avatarURL
                guard let userUID = Auth.auth().currentUser?.uid else {
                    return
                }
                uid = userUID
                downloadImage()
            }
        }
    }
    private func setupContentView() {
        contentView.addSubviews(userBlockStackView, settingsTableView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTableView() {
        settingsTableView.backgroundColor = .none
        settingsTableView.separatorColor = .brandPrimary
        settingsTableView.isScrollEnabled = false
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setupLabels() {
        userNameLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
        userNameLabel.textColor = UIColor(.white)
        userNameLabel.textAlignment = .center
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        editButtonTitle.textColor = UIColor(named: "EverydayOrange")
        editButtonTitle.font = UIFont(name: "Montserrat-Bold", size: 16)
        editButtonTitle.text = "Изм."
    }
    
    private func setupStackViews() {
        userBlockStackView.spacing = 15
        userBlockStackView.axis = .vertical
        userBlockStackView.spacing = 10
        userBlockStackView.distribution = .fill
        userBlockStackView.addArrangedSubview(userImage)
        userBlockStackView.addArrangedSubview(userNameLabel)
        
        userBlockStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupUserImage() {
        userImage.image = UIImage(named: "artur")
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.4 / 2
        userImage.clipsToBounds = true
        userImage.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Layout
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.1 * view.bounds.height),
            userImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            userImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.4),
            userImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.4),
            
            userNameLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 10),
            userNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            settingsTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            settingsTableView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 0.03 * view.bounds.height),
            settingsTableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.9),
            settingsTableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height * 0.4)
        ])
    }

    // MARK: - Actions
    
    @objc
    private func didTapFeedBackButton() {
        let profileVC = ProfileVC()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc
    private func didTapBlogButton() {
        let profileVC = ProfileVC()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc
    private func didTapFaqButton() {
        let profileVC = ProfileVC()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc
    private func didTapChangeUserImageButton() {
        let imagePickerController = UIImagePickerController()

        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc
    private func didTapEditButton() {
        let profileVC = ProfileVC()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc
    private func downloadImage() {
        let reference = Storage.storage().reference(forURL: avatarURL)
            let megaByte = Int64(3 * 1024 * 1024)
        reference.getData(maxSize: megaByte) { data, _ in
            
            guard let imageData = data else {
                return
            }
            let image = UIImage(data: imageData)
            self.userImage.image = image
        }
    }
}

extension SettingsVC: UITableViewDataSource {
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCustomCell", for: indexPath) as? SettingsTableViewCell {
            
            let cellImageConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20))
            if indexPath.section == 0 {
                let cellButton = changeImageTitleCellModel
                cell.accessoryType = .disclosureIndicator
                cell.cellImage.image = UIImage(systemName: cellButton.cellImageName, withConfiguration: cellImageConfiguration)
                cell.cellLabel.text = cellButton.cellTitle
                cell.backgroundColor = .brandPrimaryLight
                
                return cell
            } else {
                let cellButton = aboutAppCellModels[indexPath.row]
                cell.accessoryType = .disclosureIndicator
                cell.cellImage.image = UIImage(systemName: cellButton.cellImageName, withConfiguration: cellImageConfiguration)
                cell.cellLabel.text = cellButton.cellTitle
                cell.backgroundColor = .brandPrimaryLight
                
                return cell
            }
        } else {
            let defaultCell = UITableViewCell()
            return defaultCell
        }
    }
}

extension SettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * 0.05
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == settingsTableView {
            if indexPath.section == 0 {
               didTapChangeUserImageButton()
            } else {
                switch indexPath.row {
                case 0: print("dd")
                case 1: print("ss")
                case 2: print("kk")
                default: print("ll")
                }
            }
        }
    }
}

extension SettingsVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        userImage.image = image
        
        func uploadImage(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
            guard let userUID = Auth.auth().currentUser?.uid else {
                return
            }
            
            let reference = Storage.storage().reference().child("avatars").child(userUID)
            guard let imageData = userImage.image?.jpegData(compressionQuality: 0.4) else {
                return
            }
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            reference.putData(imageData, metadata: metadata) { (metadata, _) in
                guard let m = metadata else {
                    return
                }
                reference.downloadURL { (url, _) in
                    guard let url = url else {
                        return
                    }
                    completion(.success(url))
                }
            }
        }
        
        uploadImage(photo: image) { result in
            switch result {
            case .success(let url):
                SettingsService.shared.updateAvatarUrl(url: url.absoluteString)
            default: print("error")
            }
        }
    }
}

//
//  AuthScreenVC.swift
//  Everyday
//
//  Created by Михаил on 06.11.2023.
//

import UIKit

class AuthScreenVC: UIViewController {
    
    var imageArea: UIImageView!
    var textLabel: UILabel!
    var everydayLabel: UILabel!
    var regButton: UIButton!
    var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }
    
    func configureScreen() {
        view.backgroundColor = UIColor(red: 6/255, green: 38/255, blue: 55/255, alpha: 1)
        
        // расположение и установка изображения
        imageArea = UIImageView()
        addImageToUIImageView()
        view.addSubview(imageArea)
        imageArea.translatesAutoresizingMaskIntoConstraints = false
       
        let screenWidth = UIScreen.main.bounds.size.width
        let imageWidth = screenWidth * 0.75
        let imageHeight = imageWidth
        
        imageArea.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        imageArea.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        
        imageArea.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageArea.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -0.18 * view.bounds.height).isActive = true
        
        // расположение и установка текста
        textLabel = UILabel()
        textLabel.text = "Планируй, Действуй, "
        textLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        textLabel.textColor = UIColor(red: 255/255, green: 167/255, blue: 32/255, alpha: 1)
        
        everydayLabel = UILabel()
        everydayLabel.text = "Everyday"
        everydayLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
        everydayLabel.textColor = UIColor(red: 255/255, green: 167/255, blue: 32/255, alpha: 1)
        
        let textStackView = UIStackView(arrangedSubviews: [textLabel, everydayLabel])
        textStackView.axis = .horizontal
        textStackView.spacing = 1
        textStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(textStackView)
        textStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textStackView.topAnchor.constraint(equalTo: imageArea.bottomAnchor, constant: view.bounds.width * 0.02 ).isActive = true
        
        // расположение и установка кнопок
        regButton = UIButton(type: .system)
        view.addSubview(regButton)
        regButton.setTitle("Создать аккаунт", for: .normal)
        regButton.titleLabel?.font = UIFont(name: "Coves Bold", size: 16)
        regButton.setTitleColor(.black, for: .normal)
        regButton.backgroundColor = .white
        regButton.layer.cornerRadius = regButton.frame.size.height / 2
        regButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        regButton.clipsToBounds = true
       // regButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        
        regButton.translatesAutoresizingMaskIntoConstraints = false
        regButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        regButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    func addImageToUIImageView() {
        if let logotype = UIImage(named: "logo.png") {
            imageArea.image = logotype
        }
    }
    
}




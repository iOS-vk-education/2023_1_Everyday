//
//  AuthScreenVC.swift
//  Everyday
//
//  Created by Михаил on 06.11.2023.
//

import UIKit

class AuthScreenVC: UIViewController {
    
    private let imageArea = UIImageView()
    private let textLabel = UILabel()
    private let everydayLabel = UILabel()
    private let regButton = UIButton()
    private let loginButton = UIButton()
    private var textStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 6 / 255, green: 38 / 255, blue: 55 / 255, alpha: 1)
        
        view.addSubview(imageArea)
        view.addSubview(textStackView)
        view.addSubview(regButton)
        view.addSubview(loginButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let logotype = UIImage(named: "logo.png") {
            imageArea.image = logotype
        }
        
        imageArea.translatesAutoresizingMaskIntoConstraints = false
        imageArea.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.75).isActive = true
        imageArea.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.75).isActive = true
        
        imageArea.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageArea.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -0.18 * view.bounds.height).isActive = true
        
        configLabelToView(textLabel, text: "Планируй, Действуй, ", font: "Montserrat-SemiBold",
                          textcolor: UIColor(red: 255 / 255, green: 167 / 255, blue: 32 / 255, alpha: 1))
        configLabelToView(everydayLabel, text: "Everyday", font: "Montserrat-Bold",
                          textcolor: UIColor(red: 255 / 255, green: 167 / 255, blue: 32 / 255, alpha: 1))
        
        textStackView.addArrangedSubview(textLabel)
        textStackView.addArrangedSubview(everydayLabel)
        
        textStackView.axis = .horizontal
        textStackView.spacing = 1
        
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textStackView.topAnchor.constraint(equalTo: imageArea.bottomAnchor, constant: view.bounds.width * 0.02 ).isActive = true
        
        configButtonToView(regButton, title: "Создать аккаунт",
                           backgroundColor: .white,
                           topConstraintConstant: view.bounds.height * 0.02, bottomConstraintConstant: -0.17 * view.bounds.height)
        // regButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        
        configButtonToView(loginButton, title: "Войти",
                           backgroundColor: UIColor(red: 255 / 255, green: 167 / 255, blue: 32 / 255, alpha: 1),
                           topConstraintConstant: view.bounds.height * 0.05, bottomConstraintConstant: -0.1 * view.bounds.height)
    }
    
    func configLabelToView(_ label: UILabel, text: String, font: String, textcolor: UIColor) {
        label.text = text
        label.font = UIFont(name: font, size: 16)
        label.textColor = textcolor
    }
    
    func configButtonToView(_ button: UIButton, title: String, backgroundColor: UIColor,
                            topConstraintConstant: CGFloat, bottomConstraintConstant: CGFloat) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 5

        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: textStackView.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomConstraintConstant).isActive = true
    }
}

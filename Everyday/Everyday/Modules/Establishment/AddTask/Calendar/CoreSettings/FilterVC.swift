//
//  FilterVC.swift
//  Everyday
//
//  Created by Михаил on 05.12.2023.
//

import UIKit
import HorizonCalendar

final class FilterVC: UIViewController {
    
// MARK: - Properties

    var overlayView: UIView?
    let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
    var selectedFieldIndex = 0
    static private var selectedButton: UIButton?
    private var stackView = UIStackView()
    static private var isFirstLoad = true
    
    private var onUpdate: ((Int) -> Void)?
    
    init(onUpdate: ((Int) -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.onUpdate = onUpdate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let overlaySize: CGFloat = 150
        let overlay = UIView(frame: CGRect(x: (view.frame.width - overlaySize) / 2,
                                           y: (view.frame.height - overlaySize) / 2, width: overlaySize + 20, height: overlaySize))
        overlay.backgroundColor = UIColor(named: "EverydayLightBlue")
        overlay.layer.cornerRadius = 10.0

        view.addSubview(overlay)
        overlayView = overlay

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.frame = overlay.bounds

        for i in 1...2 {
            let button = UIButton(type: .system)
            button.setTitleColor(UIColor.white, for: .normal)
            if i == 1 {
                button.setTitle("Выбрать день", for: .normal)
            } else {
                button.setTitle("Выбрать период", for: .normal)
            }
            button.addTarget(self, action: #selector(openDifferentView(_:)), for: .touchUpInside)
            button.tag = i
            stackView.addArrangedSubview(button)
            
            if FilterVC.isFirstLoad {
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                checkmarkImageView.tintColor = UIColor(named: "EverydayOrange")
                button.addSubview(checkmarkImageView)
                checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    checkmarkImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10),
                    checkmarkImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
                ])
                FilterVC.isFirstLoad = false
            }

            if let selectedButton = FilterVC.selectedButton, selectedButton.tag == i {
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                checkmarkImageView.tintColor = UIColor(named: "EverydayOrange")
                button.addSubview(checkmarkImageView)
                checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    checkmarkImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10),
                    checkmarkImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
                ])
            }

            if i == 1 {
                let separatorView = UIView()
                separatorView.backgroundColor = UIColor.black
                stackView.addArrangedSubview(separatorView)
                separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
                separatorView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
            }
        }

        overlay.addSubview(stackView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideOverlay))
        view.addGestureRecognizer(tapGesture)
    }
    
// MARK: - Actions
    
    @objc func hideOverlay() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openDifferentView(_ sender: UIButton) {
        hideOverlay()
        
        FilterVC.selectedButton?.subviews.compactMap { $0 as? UIImageView }.forEach { $0.removeFromSuperview() }

        let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
        checkmarkImageView.tintColor = UIColor(named: "EverydayOrange")
        sender.addSubview(checkmarkImageView)
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false

        FilterVC.selectedButton = sender
                
        if let title = sender.titleLabel?.text {
            switch sender.tag {
            case 1:
                onUpdate?(1)
            case 2:
                onUpdate?(2)
            default:
                break
            }
        }
    }
}

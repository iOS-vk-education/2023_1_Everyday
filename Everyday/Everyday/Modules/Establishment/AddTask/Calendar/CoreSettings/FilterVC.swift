//
//  FilterVC.swift
//  Everyday
//
//  Created by Михаил on 05.12.2023.
//

import UIKit
import HorizonCalendar

class FilterVC: UIViewController {

    var overlayView: UIView?
    let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
    var selectedFieldIndex = 0
    
    private var onUpdate: ((Int) -> Void)?
    
    init(onUpdate: ((Int) -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.onUpdate = onUpdate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a new view
        let overlay = UIView(frame: CGRect(x: (view.frame.width - 200) / 2, y: (view.frame.height - 200) / 2, width: 200, height: 200))
        overlay.backgroundColor = UIColor.systemBlue

        // Set the corner radius
        overlay.layer.cornerRadius = 10.0

        // Add the new view on top of the existing one
        view.addSubview(overlay)
        overlayView = overlay

        // Add a UIStackView for vertical fields
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.frame = overlay.bounds

        // Add 4 vertical fields
        for i in 1...3 {
            let button = UIButton(type: .system)
            button.setTitle("Field \(i)", for: .normal)
            button.addTarget(self, action: #selector(openDifferentView(_:)), for: .touchUpInside)
            button.tag = i // Set a unique tag for each button
            stackView.addArrangedSubview(button)
        }

        overlay.addSubview(stackView)

        // Add the system checkmark symbol to the right of the overlay
        checkmarkImageView.tintColor = UIColor.systemOrange
        checkmarkImageView.frame = CGRect(x: overlay.bounds.width - 30, y: 10, width: 20, height: 20)
        checkmarkImageView.isHidden = false
        overlay.addSubview(checkmarkImageView)

        // Add a gesture recognizer to handle taps outside the overlay
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideOverlay))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideOverlay() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openDifferentView(_ sender: UIButton) {
        hideOverlay()
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

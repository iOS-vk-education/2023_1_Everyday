//
//  PriorityVC.swift
//  Everyday
//
//  Created by Михаил on 27.12.2023.
//

import UIKit

protocol PrioritySelectionDelegate: AnyObject {
    func didSelectPriority(_ priority: String)
}

class PriorityVC: UIViewController {
    // MARK: - Properties

    private var overlayView: UIView?
    private let checkmarkImageView = UIImageView(image: UIImage(systemName: "flag.fill"))
    weak var delegate: PrioritySelectionDelegate?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOverlay()
    }

    // MARK: - Actions

    @objc private func hideOverlay() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Private methods

    private func setupOverlay() {
        let overlaySize: CGFloat = 150
        let overlay = UIView(frame: CGRect(x: (view.frame.width - overlaySize) / 2,
                                           y: (view.frame.height - overlaySize) / 2,
                                           width: overlaySize + 20, height: overlaySize))
        overlay.backgroundColor = UIColor(named: "EverydayLightBlue")
        overlay.layer.cornerRadius = 10.0
        view.addSubview(overlay)
        overlayView = overlay

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.frame = overlay.bounds

        for (index, priority) in PriorityModel().priority.enumerated() {
                    let button = createButton(tag: index + 1, title: priority)
                    stackView.addArrangedSubview(button)

                    if index != PriorityModel().priority.count - 1 {
                        stackView.addSeparator(color: .black)
                    }
                }

        overlay.addSubview(stackView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideOverlay))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func createButton(tag: Int, title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(title, for: .normal)
        button.tag = tag
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }

    @objc func buttonTapped(sender: UIButton) {
        if let title = sender.title(for: .normal) {
            delegate?.didSelectPriority(title)
            dismiss(animated: true, completion: nil)
        }
    }
}

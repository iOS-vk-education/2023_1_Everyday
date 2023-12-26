//
//  FilterVC.swift
//  Everyday
//
//  Created by Михаил on 05.12.2023.
//

import UIKit

final class FilterVC: UIViewController {

    // MARK: - Properties

    private var overlayView: UIView?
    private let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
    private static var selectedButton: UIButton?
    private static var isFirstLoad = true

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
        setupOverlay()
    }

    // MARK: - Actions

    @objc private func hideOverlay() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func openDifferentView(_ sender: UIButton) {
        hideOverlay()
        updateSelectedButton(sender)
        onUpdate?(sender.tag)
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

        for i in 1...2 {
            let button = createButton(tag: i, title: (i == 1) ? "Выбрать день" : "Выбрать период")
            stackView.addArrangedSubview(button)

            if FilterVC.isFirstLoad || (FilterVC.selectedButton?.tag == i) {
                setupCheckmark(for: button)
            }

            if i == 1 {
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
        button.addTarget(self, action: #selector(openDifferentView(_:)), for: .touchUpInside)
        return button
    }

    private func setupCheckmark(for button: UIButton) {
        let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
        checkmarkImageView.tintColor = UIColor(named: "EverydayOrange")
        button.addSubview(checkmarkImageView)
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkmarkImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10),
            checkmarkImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        FilterVC.isFirstLoad = false
        FilterVC.selectedButton = button
    }

    private func updateSelectedButton(_ sender: UIButton) {
        FilterVC.selectedButton?.subviews.compactMap { $0 as? UIImageView }.forEach { $0.removeFromSuperview() }

        let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
        checkmarkImageView.tintColor = UIColor(named: "EverydayOrange")
        sender.addSubview(checkmarkImageView)
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false

        FilterVC.selectedButton = sender
    }
}

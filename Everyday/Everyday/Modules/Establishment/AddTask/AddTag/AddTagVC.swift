//
//  AddTagVC.swift
//  Everyday
//
//  Created by Михаил on 27.12.2023.
//

import UIKit

protocol AddTagViewDelegate: AnyObject {
    func didTapAddTagButton(tagName: String)
}

class AddTagView: UIView {

    weak var delegate: AddTagViewDelegate?

    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название тега"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить", for: .normal)
        button.addTarget(AddTagView.self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(textField)
        addSubview(addButton)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),

            addButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func didTapAddButton() {
        guard let tagName = textField.text else {
            return
        }
        delegate?.didTapAddTagButton(tagName: tagName)
    }
}

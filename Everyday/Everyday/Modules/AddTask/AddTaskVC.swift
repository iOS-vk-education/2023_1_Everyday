//
//  AddTaskVC.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit

final class AddTaskVC: UIViewController {
    
    // MARK: - Private properties
    
    private let taskNameField = UITextField()
    private let taskDescriptionField = UITextField()
    private let calendarButton = UIButton(type: .custom)
    private let tagButton = UIButton(type: .custom)
    private let priorityButton = UIButton(type: .custom)
    private let commitButton = UIButton(type: .custom)
    private let buttonStackView = UIStackView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "EverydayBlue")
    
        view.addSubviews(taskNameField, taskDescriptionField, buttonStackView)
        
        setupUI()
        
        commitButton.isEnabled = false
        taskNameField.becomeFirstResponder()
        taskNameField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        taskNameField.frame = .init(x: Constants.TitleField.marginHorisontal,
                                    y: view.safeAreaInsets.top + Constants.TitleField.marginTop,
                                    width: view.frame.width - Constants.TitleField.marginHorisontal * 2,
                                    height: Constants.TitleField.height)
        
        taskDescriptionField.frame = .init(x: Constants.DescriptionField.marginHorisontal,
                                           y: taskNameField.frame.height + Constants.DescriptionField.marginVertical,
                                           width: view.frame.width - Constants.DescriptionField.marginHorisontal * 2,
                                           height: Constants.DescriptionField.height)
        
        buttonStackView.frame = .init(x: Constants.StackViewField.marginHorisontal,
                                      y: taskDescriptionField.frame.origin.y +
                                         taskDescriptionField.frame.height +
                                         Constants.StackViewField.marginVertical,
                                      width: view.frame.width - Constants.StackViewField.marginHorisontal * 2,
                                      height: Constants.StackViewField.height)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupTextFieldsView()
        setupButtons()
        setupStackView()
    }
    
    private func setupTextFieldsView() {
        taskNameField.attributedPlaceholder = NSAttributedString(string: "Чем бы Вы хотели заняться?")
        taskDescriptionField.attributedPlaceholder = NSAttributedString(string: "Описание")
        
        taskNameField.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        taskDescriptionField.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        [taskNameField, taskDescriptionField].forEach { field in
            field.textColor = .white
            field.autocorrectionType = .no
            field.autocapitalizationType = .none
            field.attributedPlaceholder = NSAttributedString(
                    string: field.placeholder ?? "",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray,
                                 NSAttributedString.Key.paragraphStyle: paragraphStyle]
                )
        }
    }
    
    private func setupButtons() {

        calendarButton.layer.cornerRadius = 5
        calendarButton.addTarget(self, action: #selector(didTapCalendarButton), for: .touchUpInside)
        calendarButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        calendarButton.tintColor = UIColor(named: "EverydayOrange")
        
        tagButton.layer.cornerRadius = 5
        tagButton.setImage(UIImage(systemName: "tag.fill"), for: .normal)
        tagButton.tintColor = UIColor(named: "EverydayOrange")
        tagButton.addTarget(self, action: #selector(didTapTagButton), for: .touchUpInside)
        
        priorityButton.layer.cornerRadius = 5
        priorityButton.setImage(UIImage(systemName: "flag.fill"), for: .normal)
        priorityButton.tintColor = UIColor(named: "EverydayOrange")
        priorityButton.addTarget(self, action: #selector(didTapPriorityButton), for: .touchUpInside)
        
        let config = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        
        commitButton.setImage(UIImage(systemName: "arrow.right.circle.fill", withConfiguration: config), for: .normal)
        commitButton.tintColor = UIColor(named: "EverydayOrange")
        commitButton.layer.cornerRadius = 5
        commitButton.addTarget(self, action: #selector(didTapCommitButton), for: .touchUpInside)
    }
    
    private func setupStackView() {
        buttonStackView.spacing = 20
        buttonStackView.alignment = .center
        
        buttonStackView.addArrangedSubview(calendarButton)
        buttonStackView.addArrangedSubview(tagButton)
        buttonStackView.addArrangedSubview(priorityButton)
        
        let placeholderView = UIView()
        placeholderView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        buttonStackView.addArrangedSubview(placeholderView)
        
        buttonStackView.addArrangedSubview(commitButton)
    }
    
    // MARK: - Layout
     func height() -> CGFloat {
        return Constants.TitleField.marginTop +
            Constants.TitleField.height +
            Constants.DescriptionField.marginVertical +
            Constants.DescriptionField.height +
            Constants.StackViewField.marginVertical +
            Constants.StackViewField.height -
            view.safeAreaInsets.bottom
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapCalendarButton() {
        print("tapped")
    }
    
    @objc
    private func didTapTagButton() {
        print("tapped")
    }
    
    @objc
    private func didTapPriorityButton() {
        print("tapped")
    }
    
    @objc
    private func didTapCommitButton() {
        print("tapped")
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard let task = taskNameField.text, !task.isEmpty else {
            commitButton.isEnabled = false
            return
        }
        
        taskNameField.text = task.capitalized
        
        commitButton.isEnabled = true
    }

    // MARK: - Constants
    
    struct Constants {
        struct TitleField {
            static let marginTop: CGFloat = 12
            static let marginHorisontal: CGFloat = 12
            static let height: CGFloat = 40
        }
        
        struct DescriptionField {
            static let marginVertical: CGFloat = 12
            static let marginHorisontal: CGFloat = 12
            static let height: CGFloat = 40
        }
        
        struct StackViewField {
            static let marginVertical: CGFloat = 12
            static let marginHorisontal: CGFloat = 12
            static let height: CGFloat = 40
        }
    }
}

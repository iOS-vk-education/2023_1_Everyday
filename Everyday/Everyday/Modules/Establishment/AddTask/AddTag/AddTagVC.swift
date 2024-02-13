import UIKit

protocol AddTagViewDelegate: AnyObject {
    func didTapAddTagButton(tagName: String)
}

class AddTagViewController: UIViewController {
    
    // MARK: - Properties

    weak var delegate: AddTagViewDelegate?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private let textField = UITextField()

    private let addButton: UIButton = UIButton(type: .system)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
        setUpButton()
        setupUI()
        setupKeyboardNotifications()
    }
    
    // MARK: - Setup
    
    private func setUpTextField() {
        textField.attributedPlaceholder = NSAttributedString(string: "Введите название тега")
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.backgroundColor = .white
        textField.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        textField.textColor = .black
        textField.layer.cornerRadius = 5
        textField.attributedPlaceholder = NSAttributedString(
                    string: textField.placeholder ?? "",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray,
                                 NSAttributedString.Key.paragraphStyle: paragraphStyle]
                )
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpButton() {
        addButton.backgroundColor = UIColor(named: "EverydayOrange")
        addButton.setTitle("Добавить тэг", for: .normal)
        addButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        addButton.setTitleColor(.black, for: .normal)
        addButton.layer.cornerRadius = 5
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Constraints
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "EverydayBlue")
        
        view.addSubview(scrollView)
        scrollView.addSubviews(contentView, textField, addButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),

            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.23 * view.bounds.height),
            addButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.31 * view.bounds.height)
        ])
        
        [addButton, textField].forEach { element in
         element.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.75).isActive = true
         element.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
         element.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddButton() {
        guard let tagName = textField.text, !tagName.isEmpty else {
            return
        }
        delegate?.didTapAddTagButton(tagName: tagName)
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Keyboard Handling

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(gestureRecognizer)
    }

    @objc private func didTapScrollView() {
        view.endEditing(true)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrameInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }

        let keyboardHeight = keyboardFrameInfo.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight
    }

    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
}

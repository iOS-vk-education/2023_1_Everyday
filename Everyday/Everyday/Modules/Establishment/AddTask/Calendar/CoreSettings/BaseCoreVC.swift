//
//  CoreVC.swift
//  Everyday
//
//  Created by Михаил on 03.12.2023.
//

import HorizonCalendar
import UIKit

// MARK: - CoreVC

protocol CoreVC: UIViewController {
    init(monthsLayout: MonthsLayout, onUpdate: ((AddTaskVC.CalendarState) -> Void)?)
    
    var calendar: Calendar { get }
    var monthsLayout: MonthsLayout { get }
    
    func updateState(calendarState: AddTaskVC.CalendarState)
    func makeContent(calendarState: AddTaskVC.CalendarState) -> CalendarViewContent
}

// MARK: - BaseCoreVC

class BaseCoreVC: UIViewController, CoreVC {
    
// MARK: - Properties
    
    let filterButton = UIButton(type: .system)
    let closeButton = UIButton(type: .close)
    let saveButton = UIButton(type: .system)
    var onUpdate: ((AddTaskVC.CalendarState) -> Void)?
    var onDismiss: (() -> Void)?
    let monthsLayout: MonthsLayout
    
    lazy var calendarView = CalendarView(initialContent: makeContent(calendarState: .singleDaySelection))
    lazy var calendar = Calendar.current
    lazy var dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.locale = Locale(identifier: "ru_RU_POSIX")
        dateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "EEEE, MMM d, yyyy",
            options: 0,
            locale: dateFormatter.locale)
        return dateFormatter
    }()
    
// MARK: - Initialize
    
    required init(monthsLayout: MonthsLayout, onUpdate: ((AddTaskVC.CalendarState) -> Void)?) {
        self.monthsLayout = monthsLayout
        self.onUpdate = onUpdate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "EverydayBlue")
        
        calendarView.layer.cornerRadius = 10 
        calendarView.layer.masksToBounds = true
        calendarView.backgroundColor = UIColor(named: "EverydayLightBlue")

        filterButton.setImage(UIImage(systemName: "slider.vertical.3"), for: .normal)
        filterButton.tintColor = UIColor(named: "EverydayOrange")
        filterButton.addTarget(self, action: #selector(showFilterOverlay), for: .touchUpInside)

        closeButton.addTarget(self, action: #selector(closeOverlay), for: .touchUpInside)
        
        saveButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        saveButton.tintColor = UIColor(named: "EverydayOrange")
        saveButton.addTarget(self, action: #selector(saveSelectedDate), for: .touchUpInside)
        
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubviews(calendarView, filterButton, closeButton, saveButton)
        
        setupConstraints()
    }
    
// MARK: - Layout
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            filterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            filterButton.widthAnchor.constraint(equalToConstant: 90),
            filterButton.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 48),
            saveButton.widthAnchor.constraint(equalToConstant: 90),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: UIButton(type: .system).intrinsicContentSize.width),
            closeButton.heightAnchor.constraint(equalToConstant: UIButton(type: .system).intrinsicContentSize.height),
            
            calendarView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 16),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            calendarView.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(
                lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarView.widthAnchor.constraint(lessThanOrEqualToConstant: 375),
            calendarView.widthAnchor.constraint(equalToConstant: 375).prioritize(at: .defaultLow)
        ])
    }
        
// MARK: - Actions
    
    func updateState(calendarState: AddTaskVC.CalendarState) {
        fatalError("updateState(calendarState:) has not been implemented")
    }
    
    func makeContent(calendarState: AddTaskVC.CalendarState) -> CalendarViewContent {
        fatalError("Must be implemented by a subclass.")
    }
    
    @objc func showFilterOverlay() {
        let filterVC = FilterVC(onUpdate: { [weak self] intValue in
            self?.onUpdate?(AddTaskVC.CalendarState(rawValue: intValue) ?? .singleDaySelection)
        })

        filterVC.modalPresentationStyle = .overFullScreen
        present(filterVC, animated: true, completion: nil)
    }
    
    @objc func closeOverlay() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveSelectedDate() {
    }
}

// MARK: NSLayoutConstraint + Priority Helper

extension NSLayoutConstraint {
    
    fileprivate func prioritize(at priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

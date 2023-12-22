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
    
// MARK: - Private properties
    
    let filterButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    var onUpdate: ((AddTaskVC.CalendarState) -> Void)?
    var onDismiss: (() -> Void)?
    
    required init(monthsLayout: MonthsLayout, onUpdate: ((AddTaskVC.CalendarState) -> Void)?) {
        self.monthsLayout = monthsLayout
        self.onUpdate = onUpdate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "EverydayBlue")
        
        filterButton.setTitle("Filter", for: .normal)
        filterButton.addTarget(self, action: #selector(showFilterOverlay), for: .touchUpInside)
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeOverlay), for: .touchUpInside)
        
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubviews(calendarView, filterButton, closeButton)
        
        setupConstraints()
    }
    
// MARK: - Layout
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            filterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filterButton.widthAnchor.constraint(equalToConstant: 80),
            filterButton.heightAnchor.constraint(equalToConstant: 40),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 80),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
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
}

// MARK: NSLayoutConstraint + Priority Helper

extension NSLayoutConstraint {
    
    fileprivate func prioritize(at priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

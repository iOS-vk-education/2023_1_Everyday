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

  init(monthsLayout: MonthsLayout)

  var calendar: Calendar { get }
  var monthsLayout: MonthsLayout { get }
}

// MARK: - BaseCoreVC

class BaseCoreVC: UIViewController, CoreVC {
    let filterButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    
  // MARK: Lifecycle

  required init(monthsLayout: MonthsLayout) {
    self.monthsLayout = monthsLayout

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  let monthsLayout: MonthsLayout

  lazy var calendarView = CalendarView(initialContent: makeContent())
  lazy var calendar = Calendar.current
  lazy var dayDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = calendar
    dateFormatter.locale = calendar.locale
    dateFormatter.dateFormat = DateFormatter.dateFormat(
      fromTemplate: "EEEE, MMM d, yyyy",
      options: 0,
      locale: calendar.locale ?? Locale.current)
    return dateFormatter
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(named: "EverydayBlue")

    view.addSubview(calendarView)
      
              filterButton.setTitle("Filter", for: .normal)
              filterButton.addTarget(self, action: #selector(showFilterOverlay), for: .touchUpInside)
              filterButton.translatesAutoresizingMaskIntoConstraints = false
              view.addSubview(filterButton)
      
      closeButton.setTitle("Close", for: .normal) // Установите желаемый текст
              closeButton.addTarget(self, action: #selector(closeOverlay), for: .touchUpInside)
              closeButton.translatesAutoresizingMaskIntoConstraints = false
              view.addSubview(closeButton)

    calendarView.translatesAutoresizingMaskIntoConstraints = false
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

  func makeContent() -> CalendarViewContent {
    fatalError("Must be implemented by a subclass.")
  }

    @objc func showFilterOverlay() {
        let overlayVC = FilterVC()
        overlayVC.modalPresentationStyle = .overFullScreen
        present(overlayVC, animated: true, completion: nil)
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

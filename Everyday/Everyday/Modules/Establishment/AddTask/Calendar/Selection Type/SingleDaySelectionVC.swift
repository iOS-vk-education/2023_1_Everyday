//
//  SingleDaySelectionVC.swift
//  Everyday
//
//  Created by Михаил on 05.12.2023.
//

import HorizonCalendar
import UIKit

final class SingleDaySelectionVC: BaseCoreVC {

  // MARK: Lifecycle

  required init(monthsLayout: MonthsLayout) {
    super.init(monthsLayout: monthsLayout)
    selectedDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 19))!
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Single Day Selection"

    calendarView.daySelectionHandler = { [weak self] day in
        guard let self else {
            return
        }

      selectedDate = calendar.date(from: day.components)
      calendarView.setContent(makeContent())
    }
  }

  override func makeContent() -> CalendarViewContent {
    let startDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 01))!
    let endDate = calendar.date(from: DateComponents(year: 2021, month: 12, day: 31))!

    let selectedDate = selectedDate

    return CalendarViewContent(
      calendar: calendar,
      visibleDateRange: startDate...endDate,
      monthsLayout: monthsLayout)

      .interMonthSpacing(24)
      .verticalDayMargin(8)
      .horizontalDayMargin(8)

      .dayItemProvider { [calendar, dayDateFormatter] day in
        var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive

        let date = calendar.date(from: day.components)
        if date == selectedDate {
          invariantViewProperties.backgroundShapeDrawingConfig.borderColor = .blue
          invariantViewProperties.backgroundShapeDrawingConfig.fillColor = .blue.withAlphaComponent(0.15)
        }

        return DayView.calendarItemModel(
          invariantViewProperties: invariantViewProperties,
          content: .init(
            dayText: "\(day.day)",
            accessibilityLabel: date.map { dayDateFormatter.string(from: $0) },
            accessibilityHint: nil))
      }
  }

  // MARK: Private

  private var selectedDate: Date?
}

//
//  CalendarVC.swift
//  Everyday
//
//  Created by Михаил on 03.12.2023.
//

import HorizonCalendar
import UIKit

final class CalendarVC: BaseCoreVC {

  // MARK: Internal

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Day Range Selection"

    calendarView.daySelectionHandler = { [weak self] day in
        guard let self else {
            return
        }

      DayRangeSelectionHelper.updateDayRange(
        afterTapSelectionOf: day,
        existingDayRange: &selectedDayRange)

      calendarView.setContent(makeContent())
    }

    calendarView.multiDaySelectionDragHandler = { [weak self, calendar] day, state in
        guard let self else {
            return
        }

      DayRangeSelectionHelper.updateDayRange(
        afterDragSelectionOf: day,
        existingDayRange: &selectedDayRange,
        initialDayRange: &selectedDayRangeAtStartOfDrag,
        state: state,
        calendar: calendar)

      calendarView.setContent(makeContent())
    }
  }

  override func makeContent() -> CalendarViewContent {
    let startDate = calendar.date(from: DateComponents(year: 2023, month: 01, day: 01))!
    let endDate = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31))!

    let dateRanges: Set<ClosedRange<Date>>
    let selectedDayRange = selectedDayRange
    if
      let selectedDayRange,
      let lowerBound = calendar.date(from: selectedDayRange.lowerBound.components),
      let upperBound = calendar.date(from: selectedDayRange.upperBound.components)
    {
      dateRanges = [lowerBound...upperBound]
    } else {
      dateRanges = []
    }

    return CalendarViewContent(
      calendar: calendar,
      visibleDateRange: startDate...endDate,
      monthsLayout: monthsLayout)

      .interMonthSpacing(24)
      .verticalDayMargin(8)
      .horizontalDayMargin(8)

      .dayItemProvider { [calendar, dayDateFormatter] day in
        var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive

        let isSelectedStyle: Bool
        if let selectedDayRange {
          isSelectedStyle = day == selectedDayRange.lowerBound || day == selectedDayRange.upperBound
        } else {
          isSelectedStyle = false
        }

        if isSelectedStyle {
          invariantViewProperties.backgroundShapeDrawingConfig.fillColor = .systemBackground
          invariantViewProperties.backgroundShapeDrawingConfig.borderColor = UIColor(.accentColor)
        }

        let date = calendar.date(from: day.components)

        return DayView.calendarItemModel(
          invariantViewProperties: invariantViewProperties,
          content: .init(
            dayText: "\(day.day)",
            accessibilityLabel: date.map { dayDateFormatter.string(from: $0) },
            accessibilityHint: nil))
      }

      .dayRangeItemProvider(for: dateRanges) { dayRangeLayoutContext in
        DayRangeIndicatorView.calendarItemModel(
          invariantViewProperties: .init(),
          content: .init(
            framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }))
      }
  }

  // MARK: Private

  private var selectedDayRange: DayRange?
  private var selectedDayRangeAtStartOfDrag: DayRange?
}

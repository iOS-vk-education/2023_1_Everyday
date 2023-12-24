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
    }

    override func updateState(calendarState: AddTaskVC.CalendarState) {
        selectedDayRange = nil
        selectedDayRangeAtStartOfDrag = nil
        selectedDate = nil
        calendarView.daySelectionHandler = nil
        calendarView.multiDaySelectionDragHandler = nil
        calendarView.setContent(makeContent(calendarState: calendarState))

        switch calendarState {
        case .singleDaySelection:
            setupSingleDaySelectionHandler()

        case .calendar:
            setupCalendarSelectionHandlers()
        }
    }

    // MARK: Private

    private var selectedDayRange: DayRange?
    private var selectedDayRangeAtStartOfDrag: DayRange?
    private var selectedDate: Date?

    private func setupSingleDaySelectionHandler() {
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self 
            else {
                return
            }
            self.selectedDate = self.calendar.date(from: day.components)
            self.calendarView.setContent(self.makeContent(calendarState: .singleDaySelection))
        }
    }

    private func setupCalendarSelectionHandlers() {
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self 
            else {
                return
            }
            DayRangeSelectionHelper.updateDayRange(
                afterTapSelectionOf: day,
                existingDayRange: &self.selectedDayRange)
            self.calendarView.setContent(self.makeContent(calendarState: .calendar))
        }

        calendarView.multiDaySelectionDragHandler = { [weak self, calendar] day, state in
            guard let self = self 
            else {
                return
            }
            DayRangeSelectionHelper.updateDayRange(
                afterDragSelectionOf: day,
                existingDayRange: &self.selectedDayRange,
                initialDayRange: &self.selectedDayRangeAtStartOfDrag,
                state: state,
                calendar: calendar)
            self.calendarView.setContent(self.makeContent(calendarState: .calendar))
        }
    }

    override func makeContent(calendarState: AddTaskVC.CalendarState) -> CalendarViewContent {
        switch calendarState {
        case .singleDaySelection:
            return makeZalupa1()
        case .calendar:
            return makeZalupa2()
        }
    }

    private func makeZalupa1() -> CalendarViewContent {
        return makeCalendarViewContent(startDate: calendar.date(from: DateComponents(year: 2020, month: 01, day: 01))!,
                                       endDate: calendar.date(from: DateComponents(year: 2021, month: 12, day: 31))!,
                                       selectedDate: selectedDate)
    }

    private func makeZalupa2() -> CalendarViewContent {
        let startDate = calendar.date(from: DateComponents(year: 2023, month: 01, day: 01))!
        let endDate = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31))!

        let dateRanges: [ClosedRange<Date>] = selectedDayRange.flatMap { [calendar] in
            let lowerBound = calendar.date(from: $0.lowerBound.components)
            let upperBound = calendar.date(from: $0.upperBound.components)
            return lowerBound.map { [$0...upperBound!] } ?? []
        } ?? []

        return makeCalendarViewContent(startDate: startDate, endDate: endDate, selectedDate: nil, dateRanges: dateRanges)
    }

    private func makeCalendarViewContent(startDate: Date, 
                                         endDate: Date,
                                         selectedDate: Date?,
                                         dateRanges: [ClosedRange<Date>] = []) -> CalendarViewContent {
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: monthsLayout)
            .interMonthSpacing(24)
            .verticalDayMargin(8)
            .horizontalDayMargin(8)
            .dayItemProvider { [calendar, dayDateFormatter] day in
                var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive

                if let date = calendar.date(from: day.components), date == selectedDate {
                    invariantViewProperties.backgroundShapeDrawingConfig.borderColor = UIColor(named: "EverydayOrange") ?? UIColor(.clear)
                    invariantViewProperties.backgroundShapeDrawingConfig.fillColor =
                        UIColor(named: "EverydayOrange")?.withAlphaComponent(0.15) ?? UIColor.clear
                }

                return DayView.calendarItemModel(
                    invariantViewProperties: invariantViewProperties,
                    content: .init(
                        dayText: "\(day.day)",
                        accessibilityLabel: calendar.date(from: day.components).map { dayDateFormatter.string(from: $0) },
                        accessibilityHint: nil))
            }
            .dayRangeItemProvider(for: Set(dateRanges)) { dayRangeLayoutContext in
                DayRangeIndicatorView.calendarItemModel(
                    invariantViewProperties: .init(),
                    content: .init(
                        framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }))
            }
    }
}

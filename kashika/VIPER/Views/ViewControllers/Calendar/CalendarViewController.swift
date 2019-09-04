//
//  CalendarViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/03.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {

    @IBOutlet private weak var calendarView: JTAppleCalendarView!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var calendarViewAspectConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendarView()
    }
}

// MARK: - Set Up

extension CalendarViewController {

    private func setupCalendarView() {
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self

        calendarView.register(R.nib.calendarViewCell)

        let today = Date()
        calendarView.scrollToDate(today, animateScroll: false)
        updateMonthLabel(for: today)
    }

    private func updateMonthLabel(for date: Date?) {
        let calendar = Calendar(identifier: .gregorian)
        guard let date = date else {
            return
        }
        let startDate = calendar.startOfMonth(for: date)
        if let month = calendar.dateComponents([.month], from: startDate).month {
            monthLabel.text = "\(month)月"
        }
    }
}

// MARK: - JTAppleCalendarViewDataSource

extension CalendarViewController: JTAppleCalendarViewDataSource {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let calendar = Calendar(identifier: .gregorian)

        let lastYear = calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        let startDate = calendar.startOfMonth(for: lastYear)

        let nextYear = calendar.date(byAdding: .year, value: 1, to: Date()) ?? Date()
        let endDate = calendar.endOfMonth(for: nextYear)

        return ConfigurationParameters(startDate: startDate, endDate: endDate, generateOutDates: .tillEndOfRow)
    }
}

// MARK: - JTAppleCalendarViewDelegate

extension CalendarViewController: JTAppleCalendarViewDelegate {

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: R.reuseIdentifier.calendarViewCell.identifier, for: indexPath) as? CalendarViewCell
        cell?.set(cellState.text)

        if cellState.dateBelongsTo == .thisMonth {
            cell?.isHidden = false
        } else {
            cell?.isHidden = true
        }

        return cell ?? JTAppleCell()
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }

    func calendar(_ calendar: JTAppleCalendarView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        updateMonthLabel(for: visibleDates.monthDates.first?.date)
    }
}
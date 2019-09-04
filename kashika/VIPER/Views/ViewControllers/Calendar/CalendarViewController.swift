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
    }
}

// MARK: - JTAppleCalendarViewDataSource

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2019 01 01") ?? Date()
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
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
}

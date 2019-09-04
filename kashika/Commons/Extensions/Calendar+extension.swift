//
//  Calendar+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/04.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

extension Calendar {

    func startOfMonth(for date: Date) -> Date {
        // swiftlint:disable:next force_unwrapping
        return self.date(from: self.dateComponents([.year, .month], from: self.startOfDay(for: date)))!
    }

    func endOfMonth(for date: Date) -> Date {
        // swiftlint:disable:next force_unwrapping
        return self.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(for: date))!
    }
}

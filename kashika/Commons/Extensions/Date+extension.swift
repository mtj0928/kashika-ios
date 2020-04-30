//
//  Date+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/10/27.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import FirebaseFirestore

extension Date: TargetedExtensionCompatible {
}

extension TargetedExtension where Base == Date {

    func asTimestamp() -> Timestamp {
        return Timestamp(date: self.base)
    }

    func asString(format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: self.base)
    }
}

//
//  Monitor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/19.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift

class Monitor<T> {
    let value: T?
    let progress: Progress?

    private init(value: T?, progress: Progress?) {
        self.value = value
        self.progress = progress
    }

    convenience init(_ value: T) {
        self.init(value: value, progress: nil)
    }

    convenience init(_ progress: Progress) {
        self.init(value: nil, progress: progress)
    }

    func map<U>(_ mapper: (T) -> (U)) -> Monitor<U> {
        if let value = value {
            return Monitor<U>(value: mapper(value), progress: nil)
        }
        return Monitor<U>(value: nil, progress: progress)
    }
}

typealias MonitorObservable<T> = Observable<Monitor<T>>

//
//  CalendarPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/04.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

class CalendarPresenter: CalendarPresenterProtocol {
    let selectedDate: BehaviorRelay<Date?> = BehaviorRelay(value: nil)
    var output: Observable<CalendarOutputProtocol> {
        return outputSubject
    }

    let outputSubject = PublishSubject<CalendarOutputProtocol>()

    func dismiss() {
    }

    func tappedDecideButton() {
    }
}

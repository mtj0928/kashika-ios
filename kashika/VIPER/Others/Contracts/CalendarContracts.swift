//
//  CalendarContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/04.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

protocol CalendarOutputProtocol {
    var selectedDate: Date? { get }
}

protocol CalendarPresenterProtocol {
    var selectedDate: BehaviorRelay<Date?> { get }
    var output: Observable<CalendarOutputProtocol> { get }

    func dismiss()
    func tappedDecideButton()
}

//
//  ScheduledPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/09.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

class ScheduledPresenter: ScheduledPresenterProtocol {
    var debts: BehaviorRelay<[Debt]> {
        return interactor.debts
    }
    private let interactor: ScheduledInteractorProtocol

    init(interactor: ScheduledInteractorProtocol) {
        self.interactor = interactor
    }

    func getFriend(has debt: Debt) -> Single<Friend?> {
        return interactor.getFriend(has: debt)
    }

    func tapped(debt: Debt) {
    }
}

//
//  ScheduledPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/09.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxCocoa

class ScheduledPresenter: ScheduledPresenterProtocol {
    let debts: BehaviorRelay<[Debt]>
    let friends: BehaviorRelay<[String?: Friend]>

    init(debts: BehaviorRelay<[Debt]>, friends: BehaviorRelay<[String?: Friend]>) {
        self.debts = debts
        self.friends = friends
    }

    func tapped(debt: Debt) {
    }
}

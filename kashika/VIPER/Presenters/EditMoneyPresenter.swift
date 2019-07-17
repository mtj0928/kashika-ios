//
//  EditMoneyPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/16.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxCocoa

final class EditMoneyPresenter: EditMoneyPresenterProtocol {
    let money: BehaviorRelay<Int>

    private let router: EditMoneyRouterProtocol
    private let beforeViewMoney: BehaviorRelay<Int>

    init(money beforeViewMoney: BehaviorRelay<Int>, router: EditMoneyRouterProtocol) {
        self.beforeViewMoney = beforeViewMoney
        self.money = BehaviorRelay(value: beforeViewMoney.value)
        self.router = router
    }

    func tappedOkButton() {
        beforeViewMoney.accept(money.value)
        router.dismiss()
    }

    func tappedCancelButton() {
        router.dismiss()
    }
}

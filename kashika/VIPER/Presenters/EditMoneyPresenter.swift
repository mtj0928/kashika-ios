//
//  EditMoneyPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/16.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class EditMoneyPresenter: EditMoneyPresenterProtocol {
    var text: Observable<String?> {
        return textSubject
    }
    let title: Observable<String?> = BehaviorSubject(value: "金額を入力")
    let unit: Observable<String?> = BehaviorSubject(value: "円")
    let keyboardType: Observable<UIKeyboardType> = BehaviorSubject(value: .numberPad)

    private var money = 0
    private let textSubject: BehaviorSubject<String?>
    private let beforeViewMoney: BehaviorRelay<Int>
    private let router: EditMoneyRouterProtocol

    init(money beforeViewMoney: BehaviorRelay<Int>, router: EditMoneyRouterProtocol) {
        self.beforeViewMoney = beforeViewMoney
        money = beforeViewMoney.value
        self.textSubject = BehaviorSubject(value: String.convertWithComma(from: money))
        self.router = router
    }

    func inputed(text: String?) {
        let money = Int(text?.filter({ Int($0.description) != nil }) ?? "0") ?? 0
        self.money = money
        self.textSubject.onNext(String.convertWithComma(from: money))
    }

    func tappedOkButton() {
        beforeViewMoney.accept(money)
        router.dismiss()
    }

    func tappedCancelButton() {
        router.dismiss()
    }
}

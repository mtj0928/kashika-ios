//
//  AddDebtContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/05.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum DebtType: String {
    case kashi = "貸し"
    case kari = "借り"

    static func make(debt: Debt) -> DebtType {
        return make(money: debt.money)
    }

    static func make(money: Int) -> DebtType {
        return money > 0 ? .kari : .kashi
    }
}

protocol AddDebtOutputProtocol {
    var debts: Single<[Debt]> { get }
}

protocol AddDebtPresenterProtocol {
    var isDecelerating: BehaviorRelay<Bool> { get }
    var selectedIndexes: BehaviorRelay<Set<Int>> { get }
    var canBeAddDebt: Observable<Bool> { get }
    var friends: BehaviorRelay<[Friend]> { get }
    var money: BehaviorRelay<Int> { get }
    var shouldShowPlaceHolder: Observable<Bool> { get }
    var output: Observable<AddDebtOutputProtocol> { get }

    func createDebt(debtType: DebtType)
    func tappedCloseButton()
    func tappedMoneyButton()
    func dismissedFloatingPanel()
    func getStatus(at index: Int) -> CellStatus
    func selectFriend(at index: Int)
}

protocol AddDebtInteractorProtocol {
    var friends: BehaviorRelay<[Friend]> { get }

    func save(debts: [UnstoredDebt]) -> Single<[Debt]>
}

protocol AddDebtRouterProtocol {
    func dismiss()
    func toEditMoneyView(input: EditMoneyInputProtocol) -> EditMoneyOutputProtocol
}

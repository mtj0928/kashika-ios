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
    case none = "貸し借りなし"

    static func make(debt: Debt) -> DebtType {
        return make(money: debt.money)
    }

    static func make(money: Int) -> DebtType {
        return money > 0 ? .kari :
            money < 0 ? .kashi : .none
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
    var isSumSelected: Driver<Bool> { get }
    var isPerSelected: Driver<Bool> { get }
    var isWarikan: Driver<Bool> { get }
    var isEnabledWarikanSwitch: Driver<Bool> { get }
    var output: Observable<AddDebtOutputProtocol> { get }
    var selectedDate: BehaviorRelay<Date?> { get }
    var shouldOpenCalendar: BehaviorRelay<Bool> { get }
    var memo: BehaviorRelay<String?> { get }

    func tappedCloseButton()
    func tappedSumButton()
    func tappedPerButton()
    func tappedMoneyButton()
    func tappedWarikanSwitch(isActive: Bool)
    func dismissedFloatingPanel()
    func getStatus(at index: Int) -> CellStatus
    func selectFriend(at index: Int)

    func tappedKashitaOrWarikanButton()
    func tappedKaritaButton()
}

protocol AddDebtInteractorProtocol {
    var friends: BehaviorRelay<[Friend]> { get }

    func save(money: Int, friends: [Friend], paymentDate: Date?, memo: String?, type: DebtType) -> Single<[Debt]>
}

protocol AddDebtRouterProtocol {
    func dismiss()
    func presentWarikan(value: Int, friends: [Friend], type: WarikanInputMoaneyType)
    func toEditMoneyView(input: EditMoneyInputProtocol) -> EditMoneyOutputProtocol
}

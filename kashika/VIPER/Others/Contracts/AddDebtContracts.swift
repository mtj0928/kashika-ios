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

protocol AddDebtPresenterProtocol {
    var isDecelerating: BehaviorRelay<Bool> { get }
    var selectedIndexes: BehaviorRelay<Set<Int>> { get }
    var isSelected: BehaviorRelay<Bool> { get }
    var friends: BehaviorRelay<[User]> { get }
    var money: BehaviorRelay<Int> { get }
    var shouldShowPlaceHolder: Observable<Bool> { get }

    func createDebt()
    func tappedCloseButton()
    func tappedMoneyButton()
    func getStatus(at index: Int) -> CellStatus
    func selectFriend(at index: Int)
}

protocol AddDebtInteractorProtocol {
}

protocol AddDebtRouterProtocol {
    func dismiss()
    func toEditMoneyView(money: BehaviorRelay<Int>)
}

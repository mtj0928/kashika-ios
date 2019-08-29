//
//  AddDebtInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/24.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

class AddDebtInteractor: AddDebtInteractorProtocol {
    var friends: BehaviorRelay<[Friend]> {
        return friendsUseCase.friends
    }

    private let friendsUseCase = FriendUseCase()
    private let debtUseCase = DebtUseCase()

    func save(money: Int, friend: Friend, type: DebtType) -> Single<Debt> {
        let value: Int
        switch type {
        case .kari:
            value = money
        case .kashi:
            value = -money
        }

        // swiftlint:disable:next force_unwrapping
        return debtUseCase.create(money: value, friend: friend).map({ $0.data! })
    }
}

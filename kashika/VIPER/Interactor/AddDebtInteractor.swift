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

    func save(debts: [UnstoredDebt]) -> Single<[Debt]> {
        return debtUseCase.create(debts).map({ debts in
            // swiftlint:disable:next force_unwrapping
            return debts.map({ $0.data! })
        })
    }
}

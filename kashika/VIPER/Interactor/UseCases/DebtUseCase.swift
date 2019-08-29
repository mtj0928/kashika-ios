//
//  DebtUseCase.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import Ballcap

struct DebtUseCase {
    private let friendUseCase = FriendUseCase()
    private let friendRepository = FriendRepository()
    private let userRepository = UserRepository()
    private let debtRepository = DebtRepository()

    func create(_ debts: [UnstoredDebt]) -> Single<[Document<Debt>]> {
        let user = userRepository.fetchOrCreateUser()

        let unstoredDebtSingles = debts.map { unstoredDebt in
            self.friendUseCase.fetchFirst({ $0.data == unstoredDebt.friend })
                .map({ UnstoredDebt(from: unstoredDebt, document: $0) })
        }
        let unstoredDebts = Single.zip(unstoredDebtSingles)

        return Single.zip(unstoredDebts, user)
            .flatMap({ (debts: [UnstoredDebt], user: Document<User>) in
                self.debtRepository.create(debts: debts, user: user)
            })
    }
}

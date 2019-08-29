//
//  DebtRepository.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import Ballcap

struct DebtRepository {
    private let userRepository = UserRepository()
    private let debtDataStore = DebtDataStore()

    func create(debts: [UnstoredDebt], user: Document<User>) -> Single<[Document<Debt>]> {
        return debtDataStore.create(debts: debts, userDocument: user)
    }
}

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
    var debts: [Document<Debt>] {
        debtsPool.value
    }
    var debtsObservable: Observable<[Document<Debt>]> {
        debtsPool.observable
    }
    private let userRepository = UserRepository()
    private let debtDataStore = DebtDataStore()
    private let debtsPool = MemoryPoolContainer.default.resolve(Pool<Debt>.self,
                                                                ifNotExists: { Pool() })

    func create(debts: [UnstoredDebt], user: Document<User>) -> Single<[Document<Debt>]> {
        return debtDataStore.create(debts: debts, userDocument: user)
    }

    func listen(user: Document<User>) {
        let dataSource = debtDataStore.listen(user: user)
        debtsPool.listen(user: user, dataSource: dataSource)
    }
}

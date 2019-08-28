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

    func create(money: Int, friend: Document<Friend>, user: Document<User>) -> Single<Document<Debt>> {
        return debtDataStore.create(money: money, friendDocuemnt: friend, userDocument: user)
    }
}

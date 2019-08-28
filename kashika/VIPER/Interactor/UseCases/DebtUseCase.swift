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

    func create(money: Int, friend: Friend) -> Single<Document<Debt>> {
        let user = userRepository.fetchOrCreateUser()

        let friendSingle = friendUseCase.fetchFirst({ $0.data == friend })

        return Single.zip(user, friendSingle)
            .flatMap({ (user: Document<User>, friend: Document<Friend>) in
                self.debtRepository.create(money: money, friend: friend, user: user)
            })
    }
}

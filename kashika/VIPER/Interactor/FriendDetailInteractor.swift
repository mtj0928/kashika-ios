//
//  FriendDetailInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/29.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

class FriendDetailInteractor: FriendDetailInteractorProtocol {

    let friend: BehaviorRelay<Friend>
    let debts = BehaviorRelay<[Debt]>(value: [])

    private let disposeBag = DisposeBag()

    init(friend: Friend) {
        self.friend = BehaviorRelay(value: friend)

        UserUseCase().fetchOrCreateUser()
            .map { user in
                var request = DebtRequest(user: user)
                request.orders.append(Order(key: "createdAt", descending: false))
                request.predicates.append(NSPredicate("friendId", equal: friend.id as AnyObject))
                return request
        }.flatMap { request in
            DebtUseCase().fetch(request: request)
        }.subscribe(onSuccess: { [weak self] debts in
            self?.debts.accept(debts)
        }).disposed(by: disposeBag)
    }

    func payAllDebt() {
    }
}

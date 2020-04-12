//
//  ScheduledInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/12.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

final class ScheduledInteractor: ScheduledInteractorProtocol {

    let debts: BehaviorRelay<[Debt]>

    private let debtUseCase = DebtUseCase()
    private let friendUseCase = FriendUseCase(user: UserUseCase().fetchOrCreateUser())
    private let disposeBag = DisposeBag()

    init() {
        let observer = debtUseCase.listen { user in
            var request = DebtRequest(user: user)
            request.predicates.append(NSPredicate("isPaid", equal: false as AnyObject))
            request.orders.append(Order(key: "paymentDate", descending: false))
            return request
        }
        self.debts = BehaviorRelay.create(observable: observer, initialValue: [], disposeBag: disposeBag)
    }

    func getFriend(has debt: Debt) -> Single<Friend?> {
        guard let friendId = debt.friendId else {
            return Single.just(nil)
        }
        return friendUseCase.fetch(id: friendId)
    }

}

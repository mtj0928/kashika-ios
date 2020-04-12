//
//  HomeInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

class HomeInteractor: HomeInteractorProtocol {
    let user: BehaviorRelay<User?>
    let scheduledDebts: BehaviorRelay<[Debt]>
    let friends: BehaviorRelay<[String? : Friend]>
    let kashiFriend: BehaviorRelay<[Friend]>
    let kariFriend: BehaviorRelay<[Friend]>

    private let friendUseCase = FriendUseCase(user: UserUseCase().fetchOrCreateUser())
    private let userUseCase = UserUseCase()
    private let debtUseCase = DebtUseCase()
    private let disposeBag = DisposeBag()

    init() {
        user = BehaviorRelay.create(observable: userUseCase.listen().map { $0 },
                                    initialValue: nil,
                                    disposeBag: disposeBag)

        let observable = friendUseCase.listen({ FriendRequest(user: $0) })
            .map({ friends -> [String? : Friend] in
                var dictionary: [String?: Friend] = [:]
                friends.forEach({ dictionary[$0.id] = $0 })
                return dictionary
            })
        friends = BehaviorRelay.create(observable: observable,
                                       initialValue: [:],
                                       disposeBag: disposeBag)
        kariFriend = BehaviorRelay.create(observable: friendUseCase.listen({ FriendRequest(user: $0, debtType: .kari) }),
                                          initialValue: [],
                                          disposeBag: disposeBag)
        kashiFriend = BehaviorRelay.create(observable: friendUseCase.listen({ FriendRequest(user: $0, debtType: .kashi) }),
                                           initialValue: [],
                                           disposeBag: disposeBag)

        let debts = debtUseCase.listen { user in
            var request = DebtRequest(user: user)
            request.predicates.append(NSPredicate("isPaid", equal: false as AnyObject))
            request.orders.append(Order(key: "paymentDate", descending: false))
            return request
        }

        self.scheduledDebts = BehaviorRelay.create(observable: debts, initialValue: [], disposeBag: disposeBag)
    }
}

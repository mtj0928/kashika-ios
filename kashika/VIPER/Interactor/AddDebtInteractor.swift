//
//  AddDebtInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/24.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa
import Ballcap

class AddDebtInteractor: AddDebtInteractorProtocol {

    var friends: BehaviorRelay<[Friend]> {
        return friendsDisposer.behaviorRelay
    }

    private let friendsDisposer: ListenerDisposer<[Friend], DocumentsListener<Friend>>
    private let friendsUseCase = FriendUseCase()

    init() {
        let friendbsListener = friendsUseCase.listen({ FriendRequest(user: $0) })
        friendsDisposer = ListenerDisposer(friendbsListener, { $0.extractData() })
    }

    func save(debts: [UnstoredDebt]) -> Single<[Debt]> {
        return DebtUseCase().create(debts)
            .map({ $0.extractData() })
    }
}

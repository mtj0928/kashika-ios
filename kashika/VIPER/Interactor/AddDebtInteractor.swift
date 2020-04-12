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

    let friends: BehaviorRelay<[Friend]>

    private var friendsUseCase: FriendUseCase!
    private let disposeBag = DisposeBag()

    init() {
        let observable: Observable<[Friend]> = FriendUseCase(user: UserUseCase().fetchOrCreateUser())
            .listen { user in FriendRequest(user: user) }
        friends = BehaviorRelay.create(observable: observable, initialValue: [], disposeBag: disposeBag)
    }

    func save(money: Int, friends: [Friend], paymentDate: Date?, memo: String?, type: DebtType) -> Single<[Debt]> {
        return DebtUseCase().create(money: money, friends: friends, paymentDate: paymentDate, memo: memo, type: type)
    }
}

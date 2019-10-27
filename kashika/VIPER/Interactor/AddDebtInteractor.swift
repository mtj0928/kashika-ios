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

    private let friendsUseCase = FriendUseCase()
    private let disposeBag = DisposeBag()

    init() {
        let observable = friendsUseCase.listen({ FriendRequest(user: $0) })
            .map({ $0.extractData() })
        friends = BehaviorRelay.create(observable: observable, initialValue: [], disposeBag: disposeBag)
    }

    func save(money: Int, friends: [Friend], paymentDate: Date?, memo: String?, type: DebtType) -> Single<[Debt]> {
        return DebtUseCase().create(money: money, friends: friends, paymentDate: paymentDate, memo: memo, type: type).map { documents in
            documents.extractData()
        }
    }
}

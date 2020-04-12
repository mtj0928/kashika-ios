//
//  FriendListInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

class FriendListInteractor: FriendListInteractorProtocol {

    let friends: BehaviorRelay<[Friend]>
    private let disposeBag = DisposeBag()

    init() {
        let observable = FriendUseCase(user: UserUseCase().fetchOrCreateUser()).listen({ FriendRequest(user: $0) })
        friends = BehaviorRelay.create(observable: observable, initialValue: [], disposeBag: disposeBag)
    }
}

//
//  RootInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift

struct RootInteractor: RootInteractorProtocol {

    private let friendUseCase = FriendUseCase()

    func fetchOrCreateCurrentUser() -> Single<User?> {
        return UserUseCase().fetchOrCreateUser()
            .map { $0.data }
    }

    func fetchFriend(id: String?) -> Single<Friend?> {
        guard let id = id else {
            return Single.just(nil)
        }
        return friendUseCase.fetch(id: id)
            .map({ $0.data })
    }
}

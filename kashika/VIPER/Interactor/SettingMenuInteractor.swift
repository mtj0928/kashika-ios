//
//  SettingMenuInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/27.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import Ballcap

class SettingMenuInteractor: SettingMenuInteractorProtocol {

    private let userUseCase = UserUseCase()
    private let friendsUseCase = FriendUseCase(user: UserUseCase().fetchOrCreateUser())

    func signout() -> Completable {
        return userUseCase.signout()
    }

    func deleteFriends() -> Completable {
        let friendsUseCase = self.friendsUseCase

        return userUseCase.fetchOrCreateUser()
            .map { FriendRequest(user: $0) }
            .flatMap { friendsUseCase.fetch(request: $0) }
            .flatMapCompletable { friendsUseCase.delete($0) }
            .andThen(deleteDebts())
            .andThen(userUseCase.reset())
    }

    private func deleteDebts() -> Completable {
        let debtUseCase = DebtUseCase()
        let userSingle = userUseCase.fetchOrCreateUser()

        return userSingle.map { user in
            return DebtRequest(user: user)
        }.flatMap { request in
            return debtUseCase.fetch(request: request)
        }.flatMapCompletable { debts in
            return debtUseCase.delete(debts)
        }
    }
}

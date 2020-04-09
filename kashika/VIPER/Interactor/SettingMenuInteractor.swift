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
    private let friendsUseCase = FriendUseCase()

    func signout() -> Completable {
        return userUseCase.signout()
    }

    func deleteFriends() -> Completable {
        let debtUseCase = DebtUseCase()
        debtUseCase.fetch(request: <#T##DebtUseCase.Request#>)
        return userUseCase.fetchOrCreateUser()
            .map({ FriendRequest(user: $0) })
            .flatMap({ FriendUseCase().fetch(request: $0) })
            .flatMapCompletable({ FriendUseCase().delete($0) })
    }
}

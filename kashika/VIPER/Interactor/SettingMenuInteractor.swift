//
//  SettingMenuInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/27.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift

class SettingMenuInteractor: SettingMenuInteractorProtocol {

    private let userUseCase = UserUseCase()
    private let friendsUseCase = FriendUseCase()

    func signout() -> Completable {
        return userUseCase.signout()
    }

    func deleteFriends() -> Completable {
        return friendsUseCase.delete(friends: friendsUseCase.friends.value)
    }
}

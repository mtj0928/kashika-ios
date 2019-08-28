//
//  UserUseCase.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import Ballcap

struct UserUseCase {

    private let userRepository = UserRepository()

    func fetchOrCreateUser() -> Single<Document<User>> {
        return userRepository.fetchOrCreateUser()
    }

    func signout() -> Completable {
        return userRepository.signout()
    }
}

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

    func fetchOrCreateUser() -> Single<Document<User>> {
        return UserRepository().fetchOrCreateUser()
    }
}

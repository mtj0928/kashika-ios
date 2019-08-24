//
//  UserRepository.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/16.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import Ballcap

struct UserRepository {
    private let userDataStore = UserDataStore()
    private let firebaseAuthDataStore = FirebaseAuthStore()

    func fetchOrCreateUser() -> Single<Document<User>> {
        if let firebasaeUser = firebaseAuthDataStore.fetchCurrentUser() {
            return userDataStore.fetch(authId: firebasaeUser.uid)
        }
        return firebaseAuthDataStore.createUser()
            .flatMap { self.userDataStore.create(authId: $0.uid) }
    }
}

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

    func fetchOrCreateUser() -> Single<Document<User>> {
            let dataStore = UserDataStore()
            let firebaseAuthDataStore = FirebaseAuthStore()
            if let firebasaeUser = firebaseAuthDataStore.fetchCurrentUser() {
                return dataStore.fetch(authId: firebasaeUser.uid)
            }
            return firebaseAuthDataStore.createUser()
                .flatMap { dataStore.create(authId: $0.uid) }
        }
}

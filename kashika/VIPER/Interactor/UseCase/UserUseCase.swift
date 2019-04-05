//
//  UserUseCase.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift

struct UserUseCase {

    func fetchOrCreateUser() -> Single<User> {
        let dataStore = UserDataStore()
        let firebaseAuthDataStore = FirebaseAuthStore()
        if let firebasaeUser = firebaseAuthDataStore.fetchCurrentUser() {
            return dataStore.fetch(authId: firebasaeUser.uid)
        }
        return firebaseAuthDataStore.createUser().flatMap({ firebaseUser -> PrimitiveSequence<SingleTrait, User> in
            return dataStore.create(authId: firebaseUser.uid)
        })
    }
}
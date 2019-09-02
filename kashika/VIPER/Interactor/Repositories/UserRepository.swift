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
    var userObservable: Observable<Document<User>?> {
        return userPool.userObservalble
    }
    private let userDataStore = UserDataStore()
    private let userPool = MemoryPoolContainer.default.resolve(UserPool.self, ifNotExists: { UserPool() })
    private let firebaseAuthDataStore = FirebaseAuthStore()

    func fetchOrCreateUser() -> Single<Document<User>> {
        if let user = userPool.user {
            return Single.just(user)
        }
        if let firebasaeUser = firebaseAuthDataStore.fetchCurrentUser() {
            return userDataStore.fetch(authId: firebasaeUser.uid)
        }
        return firebaseAuthDataStore.createUser()
            .flatMap { self.userDataStore.create(authId: $0.uid) }
            .do(onSuccess: { self.userPool.listen(user: $0) })
    }

    func signout() -> Completable {
        return firebaseAuthDataStore.signout()
            .do(onCompleted: { self.userPool.stop() })
    }
}

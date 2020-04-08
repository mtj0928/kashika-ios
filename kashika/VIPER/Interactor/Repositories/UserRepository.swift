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

    private let firebaseAuthStore = FirebaseAuthStore()
    private let disposeBag = RxSwift.DisposeBag()

    func fetchOrCreateUser() -> Single<Document<User>> {
        if let user = firebaseAuthStore.fetchCurrentUser() {
            return Document<User>(id: user.uid).ex.get()
        }
        return firebaseAuthStore.createUser()
            .map({ Document<User>(id: $0.uid) })
            .flatMap({ $0.ex.save() })
    }

    func signout() -> Completable {
        return firebaseAuthStore.signout()
    }
}

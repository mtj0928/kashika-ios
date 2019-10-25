//
//  UserUseCase.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa
import Ballcap

struct UserUseCase {

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

    func listen() -> DocumentListener<User> {
        return Document.listen(fetchOrCreateUser())
    }

    func signout() -> Completable {
        return firebaseAuthStore.signout()
    }
}

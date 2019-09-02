//
//  FirebaseAuthStore.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import FirebaseAuth

typealias FirebaseUser = FirebaseAuth.User

struct FirebaseAuthStore {

    func createUser() -> Single<FirebaseUser> {
        return Single.create(subscribe: { observer -> Disposable in
            Auth.auth().signInAnonymously(completion: { (authResult, error) in
                if let error = error {
                    observer(.error(error))
                } else if let user = authResult?.user {
                    observer(.success(user))
                } else {
                    let error = NSError(domain: "failed create user", code: -1, userInfo: [:])
                    observer(.error(error))
                }
            })
            return Disposables.create()
        })
    }

    func fetchCurrentUser() -> FirebaseUser? {
        return Auth.auth().currentUser
    }

    func signout() -> Completable {
        return Completable.create { observer -> Disposable in
            do {
                try Auth.auth().signOut()
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
}

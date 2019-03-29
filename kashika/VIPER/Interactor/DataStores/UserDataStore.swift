//
//  UserDataStore.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift

struct UserDataStore {

    func create(authId: String) -> Single<User> {
        return Single.create(subscribe: { observer -> Disposable in
            let user = User(id: authId.description)
            user.name = authId.description
            user.save()
            observer(.success(user))
            return Disposables.create()
        })
    }

    func fetch(authId: String) -> Single<User> {
        return Single.create(subscribe: { observer -> Disposable in
            User.get(authId.description, block: { (user, error) in
                if let error = error {
                    observer(.error(error))
                } else if let user = user {
                    observer(.success(user))
                } else {
                    observer(.error(NSError(domain: "Cannot fetch User(id: \(authId).", code: -1, userInfo: nil)))
                }
            })
            return Disposables.create()
        })
    }
}

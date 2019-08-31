//
//  UserDataStore.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import Ballcap

struct UserDataStore {

    func create(authId: String) -> Single<Document<User>> {
        return Single.create(subscribe: { observer -> Disposable in
            let document = Document<User>(id: authId)
            document.data?.name = authId.description
            document.save()
            observer(.success(document))
            return Disposables.create()
        })
    }

    func fetch(authId: String) -> Single<Document<User>> {
        return Single.create(subscribe: { observer -> Disposable in
            Document<User>.get(id: authId, completion: { (document, error) in
                if let document = document {
                    observer(.success(document))
                    return
                } else if let error = error {
                    observer(.error(error))
                    return
                }
                observer(.error(NSError(domain: "Cannot fetch User(id: \(authId).", code: -1, userInfo: nil)))
            })
            return Disposables.create()
        })
    }
}

//
//  FriendDataStore.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import Pring

struct FriendDataStore {

    func create(user: User, name: String, icon: UIImage?) -> Single<Friend> {
        return Single.create { observer -> Disposable in
            let friend = Friend()
            friend.name = name
            friend.icon = icon
            user.friends.insert(friend)
            user.update()
            friend.save()
            observer(.success(friend))
            return Disposables.create()
        }
    }

    func fetch(user: User) -> Single<DataSource<Friend>> {
        return Single.create { observer -> Disposable in
            let dataSource = user.friends.order(by: \Friend.createdAt).dataSource()
            observer(.success(dataSource))
            return Disposables.create()
        }
    }
}

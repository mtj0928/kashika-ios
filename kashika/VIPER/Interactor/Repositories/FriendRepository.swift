//
//  FriendRepository.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/23.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import Ballcap

class FriendRepository {
    var friends: Observable<[Document<Friend>]> {
        friendsPool.friends
    }

    private let dataStore = FriendDataStore()
    private let friendsPool = MemoryPoolContainer.default.resolve(FriendsPool.self,
                                                           ifNotExists: { FriendsPool() })

    func create(user: Document<User>, name: String, icon: UIImage?) -> MonitorObservable<Document<Friend>> {
        return dataStore.create(user: user, name: name, icon: icon)
    }

    func listen(user: Document<User>) {
        let observable = dataStore.listen(user: user)
        friendsPool.listen(user: user, observable: observable)
    }
}

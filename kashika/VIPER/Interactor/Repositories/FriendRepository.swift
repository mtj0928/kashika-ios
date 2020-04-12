//
//  FriendRepository.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/09.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseStorage

struct FriendRepository {

    private let dataStore: FriendDataStore

    init(user: User) {
        self.dataStore = FriendDataStore(userId: user.id)
    }

    func create(name: String, icon: UIImage?) -> MonitorObservable<Friend> {
        return dataStore.create(name: name, icon: icon)
            .map { observer in return observer.map { $0.data! } }
    }

    func fetch(request: FriendRequest) -> Single<[Friend]> {
        return dataStore.fetch(request: request).map { $0.extractData() }
    }

    func fetch(id: String) -> Single<Friend?> {
        return dataStore.fetch(id: id).map { $0.data }
    }

    func delete(_ friend: Friend) -> Completable {
        friend.document().flatMapCompletable { friendDocument in
            self.dataStore.delete(friendDocument)
        }
    }

    func delete(_ friends: [Friend]) -> Completable {
        Single.zip(friends.map { $0.document() }).flatMapCompletable { friendDocuments in
            self.dataStore.delete(friendDocuments)
        }
    }

    func listen(request: FriendRequest) -> Observable<[Friend]> {
        return dataStore.listen(request)
            .map { $0.extractData() }
    }
}

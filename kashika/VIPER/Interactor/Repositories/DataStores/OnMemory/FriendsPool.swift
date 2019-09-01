//
//  FriendsPool.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/24.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Ballcap
import RxSwift
import RxCocoa

class FriendsPool {
    var friends: [Document<Friend>] {
        dataSource?.documents ?? []
    }
    var friendsObservable: Observable<[Document<Friend>]> {
        friendsSubject
    }
    private let friendsSubject = BehaviorSubject<[Document<Friend>]>(value: [])
    private var nowListeningUser: Document<User>?
    private var dataSource: DataSource<Document<Friend>>?
    private var disposeBag = RxSwift.DisposeBag()

    func listen(user: Document<User>, dataSource: DataSource<Document<Friend>>) {
        guard user.id != nowListeningUser?.id else {
            return
        }
        nowListeningUser = user

        disposeBag = DisposeBag()

        self.dataSource?.stop()
        self.dataSource = dataSource.onChanged { [weak self] (_, _) in
            self?.friendsSubject.onNext(dataSource.documents)
        }.listen()
    }
}

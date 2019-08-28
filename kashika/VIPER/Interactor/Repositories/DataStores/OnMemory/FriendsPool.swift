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
        (try? friendsSubject.value()) ?? []
    }
    var friendsObservable: Observable<[Document<Friend>]> {
        friendsSubject
    }
    private let friendsSubject = BehaviorSubject<[Document<Friend>]>(value: [])
    private var nowListeningUser: Document<User>?
    private var disposeBag = RxSwift.DisposeBag()

    func listen(user: Document<User>, observable: Observable<[Document<Friend>]>) {
        guard user.id != nowListeningUser?.id else {
            return
        }
        nowListeningUser = user

        disposeBag = DisposeBag()

        observable.subscribe(onNext: { [weak self] documents in
            self?.friendsSubject.onNext(documents)
            }, onError: { [weak self] error in
                self?.friendsSubject.onError(error)
            }, onCompleted: { [weak self] in
                self?.friendsSubject.onCompleted()
        }).disposed(by: disposeBag)
    }
}

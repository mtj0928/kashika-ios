//
//  UserPool.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/01.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import Ballcap

class UserPool {
    var user: Document<User>? {
        return try? userSubject.value()
    }
    var userObservalble: Observable<Document<User>?> {
        return userSubject
    }

    private let userSubject: BehaviorSubject<Document<User>?> = BehaviorSubject(value: nil)
    private var nowListeningUser: Document<User>?
    private var disposeBag = Ballcap.DisposeBag()

    func listen(user: Document<User>) {
        guard user.id != nowListeningUser?.id else {
            return
        }

        disposeBag = Ballcap.DisposeBag()
        user.listen { [weak self] (user, _) in
            self?.userSubject.onNext(user)
        }.disposed(by: disposeBag)

    }

    func stop() {
        userSubject.onNext(nil)
        nowListeningUser = nil
        disposeBag = Ballcap.DisposeBag()
    }
}

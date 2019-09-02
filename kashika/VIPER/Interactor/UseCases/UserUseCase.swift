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
    let user = BehaviorRelay<User?>(value: nil)

    private let userRepository = UserRepository()
    private let disposeBag = RxSwift.DisposeBag()

    init() {
        userRepository.userObservable.subscribe(onNext: { [self] user in
            self.user.accept(user?.data)
        }).disposed(by: disposeBag)
    }

    func fetchOrCreateUser() -> Single<Document<User>> {
        return userRepository.fetchOrCreateUser()
    }

    func signout() -> Completable {
        return userRepository.signout()
    }
}

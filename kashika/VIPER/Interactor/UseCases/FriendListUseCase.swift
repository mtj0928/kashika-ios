//
//  FriendListUseCase.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/16.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxCocoa
import RxSwift
import Pring

class FriendListUseCase {
    let friends = BehaviorRelay<[Friend]>(value: [])

    private var dataSource: DataSource<Friend>?
    private let disposeBag = DisposeBag()

    init() {
        let userRepository = UserRepository()
        let userSingle = userRepository.fetchOrCreateUser()

        userSingle
            .flatMap({ FriendDataStore().fetch(user: $0) })
            .subscribe(onSuccess: { [weak self] dataSource in
                self?.dataSource = dataSource
                dataSource.onCompleted { (_, friends) in
                    self?.friends.accept(friends)
                }.listen()
            }).disposed(by: disposeBag)
    }
}

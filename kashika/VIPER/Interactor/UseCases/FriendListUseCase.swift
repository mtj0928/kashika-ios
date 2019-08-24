//
//  FriendListUseCase.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/16.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa
import Ballcap

class FriendListUseCase {
    let friends = BehaviorRelay<[Friend]>(value: [])

    private var documents: [Document<Friend>]? {
        didSet {
            if let documents = self.documents {
                let friends = documents.compactMap { $0.data }
                self.friends.accept(friends)
            }
        }
    }

    private let userRepository = UserRepository()
    private let friendRepository = FriendRepository()
    private let disposeBag = RxSwift.DisposeBag()

    init() {
        userRepository
            .fetchOrCreateUser()
            .subscribe(onSuccess: { [weak self] user in
                self?.friendRepository.listen(user: user)
            }).disposed(by: disposeBag)

        friendRepository.friends
            .subscribe(onNext: { [weak self] documents in
                self?.documents = documents
            }).disposed(by: disposeBag)
    }
}

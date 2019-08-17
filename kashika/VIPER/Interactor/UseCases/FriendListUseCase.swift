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

    private let disposeBag = RxSwift.DisposeBag()

    init() {
        UserRepository()
            .fetchOrCreateUser()
            .asObservable()
            .flatMap { FriendDataStore().listen(user: $0) }
            .subscribe(onNext: { [weak self] documents in
                self?.documents = documents
            }).disposed(by: disposeBag)
    }
}

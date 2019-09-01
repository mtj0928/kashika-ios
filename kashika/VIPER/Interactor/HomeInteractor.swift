//
//  HomeInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

struct HomeInteractor: HomeInteractorProtocol {
    var user: BehaviorRelay<User?> {
        return userUseCase.user
    }
    let scheduledFriend: BehaviorRelay<[Friend]> = BehaviorRelay(value: [])
    let kashiFriend: BehaviorRelay<[Friend]> = BehaviorRelay(value: [])
    let kariFriend: BehaviorRelay<[Friend]> = BehaviorRelay(value: [])

    private let userUseCase = UserUseCase()
    private let friendUseCase = FriendUseCase()
    private let disposeBag = DisposeBag()

    init() {
        friendUseCase.friends.subscribe(onNext: { [self] _ in
            self.userUseCase.fetchOrCreateUser().subscribe(onSuccess: { [self] document in
                self.user.accept(document.data)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)

        friendUseCase.friends.map({ (friends: [Friend]) -> [Friend] in
            return friends.filter({ Int($0.totalDebt.rawValue) > 0 })
        }).subscribe(onNext: { [self] friends in
            self.kariFriend.accept(friends)
        }).disposed(by: disposeBag)

        friendUseCase.friends.map({ (friends: [Friend]) -> [Friend] in
            return friends.filter({ Int($0.totalDebt.rawValue) < 0 })
        }).subscribe(onNext: { [self] friends in
            self.kashiFriend.accept(friends)
        }).disposed(by: disposeBag)
    }
}

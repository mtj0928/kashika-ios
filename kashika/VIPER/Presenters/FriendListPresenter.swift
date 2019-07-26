//
//  FriendListPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/25.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxCocoa

class FriendListPresenter: FriendListPresenterProtocol {

    var friends: BehaviorRelay<[User]> = BehaviorRelay(value: [])

    private let router: FriendListRouterProtocol!

    init(router: FriendListRouterProtocol) {
        self.router = router
    }

    func tappedAddUserButton(with type: UserAdditionType) {
        router.showUserAddView(with: type)
    }

    func tapped(user: User) {
    }
}

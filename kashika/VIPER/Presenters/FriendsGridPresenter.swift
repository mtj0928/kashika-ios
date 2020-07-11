//
//  FriendsGridPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/01.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxCocoa

class FriendsGridPresenter: FriendsGridPresenterProtocol {
    let friends: BehaviorRelay<[Friend]>
    let router: FriendsGridRouterProtocol

    init(_ friends: BehaviorRelay<[Friend]>, router: FriendsGridRouterProtocol) {
        self.friends = friends
        self.router = router
    }

    func tapped(friend: Friend) {
        router.present(friend: friend)
    }
}

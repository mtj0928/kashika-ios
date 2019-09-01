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
    let tappedHandler: ((Friend) -> Void)?

    init(_ friends: BehaviorRelay<[Friend]>) {
        self.friends = friends
        self.tappedHandler = nil
    }

    init(_ friends: BehaviorRelay<[Friend]>, tappedHandler: @escaping (Friend) -> Void) {
        self.friends = friends
        self.tappedHandler = tappedHandler
    }

    func tapped(friend: Friend) {
        tappedHandler?(friend)
    }
}

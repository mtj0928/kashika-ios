//
//  FriendListPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/25.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxCocoa

class FriendListPresenter: FriendListPresenterProtocol {

    var friends: BehaviorRelay<[Friend]> {
        return interactor.friends
    }

    private let interactor: FriendListInteractorProtocol
    private let router: FriendListRouterProtocol

    init(interactor: FriendListInteractorProtocol, router: FriendListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func tappedAddUserButton(with type: UserAdditionType) {
        router.showUserAddView(with: type)
    }

    func tapped(friend: Friend) {
    }
}

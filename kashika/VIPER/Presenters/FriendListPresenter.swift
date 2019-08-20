//
//  FriendListPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/25.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxCocoa

class FriendListPresenter: FriendListPresenterProtocol {

    typealias Router = FriendListRouterProtocol & SNSFooterRouterProtocol

    var friends: BehaviorRelay<[Friend]> {
        return interactor.friends
    }

    private let interactor: FriendListInteractorProtocol
    private let router: Router

    init(interactor: FriendListInteractorProtocol, router: Router) {
        self.interactor = interactor
        self.router = router
    }

    func tapped(friend: Friend) {
    }
}

// MARK: - SNSFooterPresenterProtocol

extension FriendListPresenter: SNSFooterPresenterProtocol {

    func tappedAddUserButton(with type: UserAdditionType) {
        router.showUserAddView(with: type)
    }
}

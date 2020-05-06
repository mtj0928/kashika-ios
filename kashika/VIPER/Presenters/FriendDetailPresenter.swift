//
//  FriendDetailPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/23.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

class FriendDetailPresenter: FriendDetailPresenterProtocol {

    var friend: BehaviorRelay<Friend> {
        return interactor.friend
    }
    var debts: BehaviorRelay<[Debt]> {
        return interactor.debts
    }

    private let interactor: FriendDetailInteractorProtocol
    private let router: FriendDetailRouterProtocol

    init(interactor: FriendDetailInteractorProtocol, router: FriendDetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func payAllDebt() {
    }

    func dismiss() {
        router.dismiss()
    }

    func tapDetail(fot debt: Debt) {
    }
}

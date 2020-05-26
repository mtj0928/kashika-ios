//
//  HomeContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

protocol HomePresenterProtocol {
    var sections: BehaviorRelay<[HomeSection]> { get }
    var userTotalDebtMoney: BehaviorRelay<Int> { get }

    func resolveFriendGridPresenter(for section: HomeSection) -> FriendsGridPresenterProtocol?
    func resolveScheduledPresenter() -> ScheduledPresenterProtocol
}

protocol HomeInteractorProtocol {
    var user: BehaviorRelay<User?> { get }
    var scheduledDebts: BehaviorRelay<[Debt]> { get }
    var kashiFriend: BehaviorRelay<[Friend]> { get }
    var kariFriend: BehaviorRelay<[Friend]> { get }
}

protocol HomeRouterProtocol: FriendsGridRouterProtocol {
}

protocol FriendsGridPresenterProtocol {
    var friends: BehaviorRelay<[Friend]> { get }

    func tapped(friend: Friend)
}

protocol FriendsGridRouterProtocol {
    func present(friend: Friend)
}

protocol ScheduledPresenterProtocol {
    var debts: BehaviorRelay<[Debt]> { get }

    func tapped(debt: Debt)
    func getFriend(has debt: Debt) -> Single<Friend?>
}

protocol ScheduledInteractorProtocol {
    var debts: BehaviorRelay<[Debt]> { get }

    func getFriend(has debt: Debt) -> Single<Friend?>
}

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

    func resolvePresenter(for section: HomeSection) -> FriendsGridPresenterProtocol?
}

protocol HomeInteractorProtocol {
    var user: BehaviorRelay<User?> { get }
    var scheduledFriend: BehaviorRelay<[Friend]> { get }
    var kashiFriend: BehaviorRelay<[Friend]> { get }
    var kariFriend: BehaviorRelay<[Friend]> { get }
}

protocol FriendsGridPresenterProtocol {
    var friends: BehaviorRelay<[Friend]> { get }

    func tapped(friend: Friend)
}

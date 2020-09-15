//
//  SimpleFriendListContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/09/06.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SimpleFriendListPresenterProtocol {
    var friends: BehaviorRelay<[Friend]> { get }
    var title: Driver<String?> { get }

    func select(_ friend: Friend)
    func close()
}

protocol SimpleFriendListInteractorProtocol {
    var friends: BehaviorRelay<[Friend]> { get }

    func select(_ friend: Friend) -> Completable
}

protocol SimpleFriendListRouterProtocol {
    func select(_ friend: Friend)
    func close()
}

//
//  FriendListContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/24.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxCocoa

protocol FriendListPresenterProtocol {
    var friends: BehaviorRelay<[Friend]> { get }

    func tapped(friend: Friend)
    func tappedLinkButton(friend: Friend)
}

protocol FriendListInteractorProtocol {
    var friends: BehaviorRelay<[Friend]> { get }
}

protocol FriendListRouterProtocol {
    func showDetailView(for friend: Friend)
}

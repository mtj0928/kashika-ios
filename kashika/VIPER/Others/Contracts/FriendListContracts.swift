//
//  FriendListContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/24.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxCocoa

enum UserAdditionType {
    case manual, sns
}

protocol FriendListPresenterProtocol {
    var friends: BehaviorRelay<[User]> { get }

    func tappedAddUserButton(with: UserAdditionType)
    func tapped(user: User)
}

protocol FriendListInteractorProtocol {
    var friends: BehaviorRelay<[User]> { get }
}

protocol FriendListRouterProtocol {
    func shoUserDetailView()
    func showUserAddView(with: UserAdditionType)
}

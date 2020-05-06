//
//  FriendDetailContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/23.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol FriendDetailPresenterProtocol {
    var friend: BehaviorRelay<Friend> { get }
    var debts: BehaviorRelay<[Debt]> { get }

    func payAllDebt()
    func dismiss()
    func tapDetail(fot debt: Debt)
}

protocol FriendDetailInteractorProtocol {
    var friend: BehaviorRelay<Friend> { get }
    var debts: BehaviorRelay<[Debt]> { get }

    func payAllDebt()
}

protocol FriendDetailRouterProtocol {

    func dismiss()
    func tapDetail(fot debt: Debt)
}

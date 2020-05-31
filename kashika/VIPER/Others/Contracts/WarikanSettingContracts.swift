//
//  WarikanSettingContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/30.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxCocoa

struct WarikanUser {
    let user: User?
    let friend: Friend?
    var value: Int

    var isMe: Bool {
        user != nil
    }
    var name: String? {
        return isMe ? "自分" : friend?.name
    }
    var isSelected: Bool {
        return value != 0
    }
}

protocol WarikanSettingPresenterProtocol {
    var usersWhoHavePaid: BehaviorRelay<[WarikanUser]> { get }
    var usersWhoWillPay: BehaviorRelay<[WarikanUser]> { get }

    func tappedSaveButton()
}

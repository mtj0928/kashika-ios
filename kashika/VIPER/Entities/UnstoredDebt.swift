//
//  UnstoredDebt.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Ballcap

struct UnstoredDebt {
    let money: Int
    let friend: Friend
    let document: Document<Friend>?

    init(money: Int, friend: Friend, type: DebtType) {
        switch type {
        case .kari:
            self.money = money
        case .kashi:
            self.money = -money
        }
        self.friend = friend
        self.document = nil
    }

    init(from debt: UnstoredDebt, document: Document<Friend>) {
        self.money = debt.money
        self.friend = debt.friend
        self.document = document
    }
}

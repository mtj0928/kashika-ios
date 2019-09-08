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
    let paymentDate: Date?
    let memo: String?
    let document: Document<Friend>?

    init(money: Int, friend: Friend, paymentDate: Date?, memo: String?, type: DebtType) {
        switch type {
        case .kari:
            self.money = money
        case .kashi:
            self.money = -money
        }
        self.friend = friend
        self.paymentDate = paymentDate
        self.memo = memo
        self.document = nil
    }

    init(from debt: UnstoredDebt, document: Document<Friend>) {
        self.money = debt.money
        self.friend = debt.friend
        self.paymentDate = debt.paymentDate
        self.memo = debt.memo
        self.document = document
    }
}

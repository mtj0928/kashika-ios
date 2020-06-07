//
//  WarikanDebtFlow.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/06/05.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

struct WarikanDebtFlow {
    let from: WarikanUserWhoHasPaid
    let to: WarikanUserWhoWillPay
    let value: Int
}

//
//  EditMoneyContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/16.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

protocol EditMoneyPresenterProtocol: ModalTextFieldPresenterProtocol {
}

protocol EditMoneyRouterProtocol {
    func dismiss()
}

protocol EditMoneyOutputProtocol {
    var money: BehaviorRelay<Int> { get }
}

struct EditMoneyOutput: EditMoneyOutputProtocol {
    let money: BehaviorRelay<Int>

    init(money: Int = 0) {
        self.money = BehaviorRelay(value: money)
    }
}


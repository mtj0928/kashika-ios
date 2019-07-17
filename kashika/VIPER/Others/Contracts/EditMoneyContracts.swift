//
//  EditMoneyContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/16.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxCocoa

protocol EditMoneyPresenterProtocol {
    var money: BehaviorRelay<Int> { get }

    func tappedOkButton()
    func tappedCancelButton()
}

protocol EditMoneyRouterProtocol {
    func dismiss()
}

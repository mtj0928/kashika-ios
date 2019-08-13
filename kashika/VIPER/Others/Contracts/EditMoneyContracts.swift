//
//  EditMoneyContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/16.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift

protocol EditMoneyPresenterProtocol: ModalTextFieldPresenterProtocol {
    var output: EditMoneyOutputProtocol { get }
}

protocol EditMoneyRouterProtocol {
    func dismiss()
}

protocol EditMoneyInputProtocol {
    var money: Int { get }
}

struct EditMoneyInput: EditMoneyInputProtocol {
    let money: Int
}

protocol EditMoneyOutputProtocol {
    var money: Observable<Int> { get }
}

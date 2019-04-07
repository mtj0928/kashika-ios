//
//  AddDebtContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/05.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AddDebtPresenterProtocol {
    var friends: BehaviorRelay<[User]> { get }
    var money: BehaviorRelay<Int> { get }

    func createDebt()
    func tappedCloseButton()
}

protocol AddDebtInteractorProtocol {
}

protocol AddDebtRouterProtocol {
    func dismiss()
}

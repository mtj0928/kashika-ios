//
//  HomeContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

protocol HomePresenterProtocol {
    var sections: BehaviorRelay<[HomeSection]> { get }
    var userTotalDebtMoney: BehaviorRelay<Int> { get }
}

protocol HomeInteractorProtocol {
    var user: BehaviorRelay<User?> { get }
    var scheduledFriend: BehaviorRelay<[Friend]> { get }
    var kashiFriend: BehaviorRelay<[Friend]> { get }
    var kariFriend: BehaviorRelay<[Friend]> { get }
}

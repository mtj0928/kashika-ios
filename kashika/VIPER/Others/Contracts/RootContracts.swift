//
//  RootConstracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RootPresenterProtocol {
    var canShowFloatingPannel: BehaviorRelay<Bool> { get }
    var messages: Observable<MessageNotification> { get }

    func showFloatingPannel()
}

protocol RootInteractorProtocol {
    func fetchOrCreateCurrentUser() -> Single<User?>
    func fetchFriend(id: String?) -> Single<Friend?>
}

protocol RootRouterProtocol {
    func showFloatingPannel(_ canShowFloatingPannel: BehaviorRelay<Bool>) -> Observable<AddDebtOutputProtocol>
}

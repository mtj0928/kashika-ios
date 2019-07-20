//
//  RootConstracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol RootPresenterProtocol {

    var floatingPanelContentViewController: BehaviorRelay<UIViewController?> { get }
    var canShowFloatingPannel: BehaviorRelay<Bool> { get }

    func showFloatingPannel()
}

protocol RootInteractorProtocol {
    func fetchOrCreateCurrentUser() -> Single<User>
}

protocol RootRouterProtocol {
    func showFloatingPannel(_ canShowFloatingPannel: BehaviorRelay<Bool>)
}

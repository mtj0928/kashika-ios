//
//  RootPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct RootPresenter: RootPresenterProtocol {
    let canShowFloatingPannel = BehaviorRelay<Bool>(value: false)
    let floatingPanelContentViewController = BehaviorRelay<UIViewController?>(value: nil)

    private let interactor: RootInteractorProtocol
    private let router: RootRouterProtocol
    private let disposeBag = DisposeBag()

    init(interactor: RootInteractorProtocol, router: RootRouterProtocol) {
        self.interactor = interactor
        self.router = router
        floatingPanelContentViewController.accept(AddDebtViewBuilder.build(canShowFloatingPannel))

        interactor.fetchOrCreateCurrentUser().subscribe().disposed(by: disposeBag)
    }

    func showFloatingPannel() {
        router.showFloatingPannel(canShowFloatingPannel)
    }
}

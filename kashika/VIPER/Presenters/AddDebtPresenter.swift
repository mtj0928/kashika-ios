//
//  AddDebtPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/05.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

final class AddDebtPresenter: AddDebtPresenterProtocol {

    private let router: AddDebtRouterProtocol

    init(router: AddDebtRouterProtocol) {
        self.router = router
    }

    func createDebt() {
    }

    func tappedCloseButton() {
        router.dismiss()
    }
}

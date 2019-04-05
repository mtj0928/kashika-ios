//
//  AddDebtViewBuilder.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/05.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

final class AddDebtViewBuilder {

    static func build() -> AddDebtViewController {
        let router = AddDebtRouter()
        let presenter = AddDebtPresenter(router: router)
        let viewController = AddDebtViewController.createFromStoryboard(presenter: presenter)
        router.viewController = viewController
        return viewController
    }
}

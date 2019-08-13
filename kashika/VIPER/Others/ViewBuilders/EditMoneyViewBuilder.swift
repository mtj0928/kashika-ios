//
//  EditMoneyViewBuilder.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/17.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxCocoa

struct EditMoneyViewBuilder {
    
    static func build(output: EditMoneyOutputProtocol) -> UIViewController {
        let router = EditMoneyRouter()
        let presenter = EditMoneyPresenter(router: router, output: output)
        let viewController = EditMoneyViewController.createFromStoryboard(presenter: presenter)
        router.viewController = viewController
        return viewController
    }
}

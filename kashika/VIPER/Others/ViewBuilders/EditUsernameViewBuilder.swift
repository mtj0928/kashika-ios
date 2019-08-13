//
//  EditUsernameViewBuilder.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxCocoa

struct EditUsernameViewBuilder {

    static func build(input: EditUsernameInputProtocol) -> (viewController: UIViewController, output: EditUsernameOutputProtocol) {
        let router = EditUsernameRouter()
        let presenter = EditUsernamePresenter(router: router, input: input)
        let viewController = EditUsernameViewController.createFromStoryboard(with: presenter)
        router.viewController = viewController
        return (viewController, presenter.output)
    }
}

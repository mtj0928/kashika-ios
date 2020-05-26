//
//  HomViewBuilder.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

struct HomeViewBuilder {

    static func build() -> UIViewController {
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)
        let viewController = HomeViewController.createFromStoryboard(with: presenter)
        router.rootViewController = viewController
        return viewController
    }
}

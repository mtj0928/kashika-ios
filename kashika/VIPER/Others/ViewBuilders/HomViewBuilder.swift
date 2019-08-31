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
        let presenter = HomePresenter(interactor: interactor)
        let viewController = HomeViewController.createFromStoryboard(with: presenter)
        return viewController
    }
}

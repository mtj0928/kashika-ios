//
//  AppRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/27.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import UIKit
import ESTabBarController

struct AppRouter {

    func createRootViewController() -> UIViewController {
        let router = RootRouter()
        let presenter = RootPresenter(router: router)
        let viewController = RootViewController()
        viewController.setup(presenter: presenter)
        router.viewController = viewController

        let viewControllers = (0..<5).map { index -> UIViewController in
            let plainVC = index != 3 ? UIViewController() : createFriendListViewController()
            plainVC.tabBarItem = UITabBarItem(title: index.description, image: nil, tag: index)
            return plainVC
        }
        let button = TabbarButton()
        viewControllers[2].tabBarItem = ESTabBarItem(button, title: nil, image: R.image.plusWhite())
        viewController.setViewControllers(viewControllers, animated: true)

        return viewController
    }

    private func createFriendListViewController() -> UIViewController {
        let viewController = FriendListViewController.createFromStoryboard()
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}

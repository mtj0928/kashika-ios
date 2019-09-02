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
        let interactor = RootInteractor()
        let router = RootRouter()
        let presenter = RootPresenter(interactor: interactor, router: router)
        let viewController = RootViewController()
        viewController.setup(presenter: presenter)
        router.viewController = viewController

        let viewControllers = [
            createHomeViewController(tag: 0),
            createNotificationViewController(tag: 1),
            createEmptyViewController(tag: 2),
            createFriendListViewController(tag: 3),
            createSettingMenuViewController(tag: 4)
        ]
        let button = TabbarButton()
        viewControllers[2].tabBarItem = ESTabBarItem(button, title: nil, image: R.image.plusWhite())
        viewController.setViewControllers(viewControllers, animated: true)
        return viewController
    }

    private func createHomeViewController(tag: Int) -> UIViewController {
        let viewController = HomeViewBuilder.build()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: "ホーム", image: nil, tag: tag)
        return navigationController
    }

    private func createNotificationViewController(tag: Int) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = UIColor.app.systemBackground
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: "通知", image: nil, tag: tag)
        return navigationController
    }

    private func createEmptyViewController(tag: Int) -> UIViewController {
        let viewController = UIViewController()
        viewController.tabBarItem = UITabBarItem(title: nil, image: nil, tag: tag)
        return viewController
    }

    private func createFriendListViewController(tag: Int) -> UIViewController {
        let viewController = FriendListViewBuilder.build()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: "友達", image: nil, tag: tag)
        return navigationController
    }

    private func createSettingMenuViewController(tag: Int) -> UIViewController {
        let input = SettingMenuInput(sections: [.about, .debug])
        let interactor = SettingMenuInteractor()
        let router = SettingMenuRouter()
        let presenter = SettingMenuPresenter(input: input, interactor: interactor, router: router)
        let viewController = SettingMenuViewController.createFromStoryboard(with: presenter)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: "設定", image: nil, tag: tag)
        return navigationController
    }
}

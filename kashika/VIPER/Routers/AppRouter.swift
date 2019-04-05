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
        let presenter = RootPresenter()
        let viewController = RootViewController()
        viewController.setup(presenter: presenter)

        let viewControllers = (0..<5).map { index -> UIViewController in
            let plainVC = UIViewController()
            plainVC.tabBarItem = UITabBarItem(title: index.description, image: nil, tag: index)
            plainVC.view.backgroundColor = UIColor.white
            return plainVC
        }
        let button = TabbarButton()
        viewControllers[2].tabBarItem = ESTabBarItem(button, title: nil, image: R.image.plusWhite())
        viewController.setViewControllers(viewControllers, animated: true)

        return viewController
    }
}
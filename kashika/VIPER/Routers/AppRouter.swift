//
//  AppRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/27.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import UIKit

struct AppRouter {

    func createRootViewController() -> UIViewController {
        let presenter = RootPresenter()
        let viewController = RootViewController()
        viewController.setup(presenter: presenter)

        let viewControllers = (0..<4).map { index -> UIViewController in
            let plainVC = UIViewController()
            plainVC.tabBarItem = UITabBarItem(title: index.description, image: nil, tag: index)
            plainVC.view.backgroundColor = UIColor.white
            return plainVC
        }
        viewController.setViewControllers(viewControllers, animated: true)
        return viewController
    }
}

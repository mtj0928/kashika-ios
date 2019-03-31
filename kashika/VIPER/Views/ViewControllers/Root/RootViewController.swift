//
//  RootViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import ESTabBarController

final class RootViewController: ESTabBarController {

    typealias Presenter = RootPresenterProtocol

    private var presenter: Presenter!

    // viewDidLoad() of UITabbarController is started when it is made.
    func setup(presenter: Presenter) {
        self.presenter = presenter

        setupTabbar()
    }
}

// MARK: - Set Up

extension RootViewController {

    private func setupTabbar() {
        shouldHijackHandler = { tabbarController, viewController, index in
            return index == 2
        }

        didHijackHandler = { tabbarController, viewController, index in
            // タップされたらここに入る
        }
    }
}

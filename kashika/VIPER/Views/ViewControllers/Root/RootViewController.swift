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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // viewDidLoad() of UITabbarController is started when it is made.
    func setup(presenter: Presenter) {
        self.presenter = presenter
    }
}

// MARK: - Set Up

extension RootViewController {

}

//
//  FriendListViewBuilder.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/25.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

struct FriendListViewBuilder {

    static func build() -> UIViewController {
        let router = FriendListRouter()
        let presenter = FriendListPresenter(router: router)
        let viewController = FriendListViewController.createFromStoryboard(with: presenter)
        return viewController
    }
}

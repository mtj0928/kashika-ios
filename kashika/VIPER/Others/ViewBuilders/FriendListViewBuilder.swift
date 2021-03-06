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
        let interactor = FriendListInteractor()
        let router = FriendListRouter()
        let presenter = FriendListPresenter(interactor: interactor, router: router)
        let viewController = FriendListViewController.createFromStoryboard(friendListpresenter: presenter, footerPresenter: presenter)
        router.viewController = viewController
        return viewController
    }
}

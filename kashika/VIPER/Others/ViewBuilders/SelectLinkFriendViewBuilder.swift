//
//  SelectLinkFriendViewBuilder.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/09/13.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class SelectLinkFriendViewBuilder {

    func build(userId: String, friendId: String, token: String, completion: @escaping (Bool) -> Void) -> UIViewController {
        let router = SelectLinkFriendRouter()
        router.completion = completion
        let interactor = SelectLinkFriendInteractor(userId: userId, friendId: friendId, token: token)
        let presenter = SelectLinkFriendPresenter(interactor: interactor, router: router)
        let viewController = SimpleFriendListViewController.createFromStoryboard(with: presenter)
        let navigationController = UINavigationController(rootViewController: viewController)
        router.viewController = navigationController

        return navigationController
    }
}

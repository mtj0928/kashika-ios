//
//  HomeRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/26.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class HomeRouter: HomeRouterProtocol {

    weak var rootViewController: UIViewController?

    func present(friend: Friend) {
        let viewController = FriendDetailViewBuilder.build(friend: friend)
        rootViewController?.present(viewController, animated: true)
    }
}

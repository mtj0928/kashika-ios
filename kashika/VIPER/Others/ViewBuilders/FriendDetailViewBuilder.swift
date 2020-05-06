//
//  FriendDetailViewBuilder.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/23.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

struct FriendDetailViewBuilder {

    static func build(friend: Friend) -> UIViewController {
        let router = FriendDetailRouter()
        let interactor = FriendDetailInteractor(friend: friend)
        let presenter = FriendDetailPresenter(interactor: interactor, router: router)
        let viewController = FriendDetailViewController.createFromStoryboard(with: presenter)

        router.viewController = viewController
        let floatingPanelController = FloatingPanelBuilder.build()

        floatingPanelController.delegate = viewController
        floatingPanelController.set(contentViewController: viewController)
        floatingPanelController.track(scrollView: viewController.scrollView)

        return floatingPanelController
    }
}

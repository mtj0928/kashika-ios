//
//  FriendListRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/26.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class FriendListRouter: FriendListRouterProtocol {

    weak var viewController: UIViewController?

    func shoUserDetailView() {
    }
}

// MARK: - SNSFooterRouterProtocol

extension FriendListRouter: SNSFooterRouterProtocol {

    func showUserAddView(with type: UserAdditionType) {
        switch type {
        case .manual:
            showAddUserManualyView()
        case .sns:
            break
        }
    }

    private func showAddUserManualyView() {
        let viewController = AddUserManualyViewBuilder.build()
        self.viewController?.present(viewController, animated: true)
    }
}

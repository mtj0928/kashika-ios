//
//  ConfirmationInviteRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/26.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import UIKit

class ConfirmationInviteRouter: ConfirmationInviteRouterProtocol {
    let userId: String
    let friendId: String
    let token: String

    weak var viewController: UIViewController?
    weak var view: PopupView?

    init(userId: String, friendId: String, token: String) {
        self.userId = userId
        self.friendId = friendId
        self.token = token
    }

    func dismiss() {
        view?.dismiss()
        view?.removeFromSuperview()
    }

    func presentFriendList(for friend: FetchFriendWithToken.FetchedFriend) {
        let viewBuilder = SelectLinkFriendViewBuilder()

        let viewController = viewBuilder.build(userId: userId, friendId: friendId, token: token) { [weak self] isSelected in
            if isSelected {
                self?.dismiss()
            }
        }
        self.viewController?.present(viewController, animated: true)
    }
}

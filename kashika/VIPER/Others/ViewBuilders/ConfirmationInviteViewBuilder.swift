//
//  ConfirmationInviteViewBuilder.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/26.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import UIKit

struct ConfirmationInviteViewBuilder {

    static func build(friend: FetchFriendWithToken.FetchedFriend, userId: String, friendId: String, token: String, view: UIView) -> PopupView {

        let contentView = InvitePopupView()
        contentView.backgroundColor = UIColor.app.cardViewBackgroundColor
        let router = ConfirmationInviteRouter()
        let interactor = ConfirmationInviteInteractor(userId: userId, friendId: friendId, token: token)
        let presenter = ConfirmationInvitePresenter(friend, interactor: interactor, router: router)
        contentView.presenter = presenter

        let width = 0.8 * view.frame.width
        let popupView = PopupView()
        popupView.contentSize = CGSize(width: width, height: 1.2 * width)
        popupView.contentView = contentView

        router.view = popupView

        view.addSubview(popupView)
        popupView.fillSuperview()

        return popupView
    }
}

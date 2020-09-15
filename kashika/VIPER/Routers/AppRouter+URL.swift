//
//  AppRouter+URL.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/23.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import FirebaseFunctions
import SVProgressHUD

extension AppRouter {

    func handleDeeplink(_ url: URL) {
        guard let type = url.deeplinkType else {
            return
        }

        switch type {
        case .friendInvite:
            self.handleFriendInviteDeeplink(url)
        }
    }
}

extension AppRouter {

    private func handleFriendInviteDeeplink(_ url: URL) {
        guard let request = FetchFriendWithToken.Request.parse(url: url) else {
            return
        }

        SVProgressHUD.show()
        _ = FetchFriendWithToken.call(request)
            .subscribe(onSuccess: { friend in
                guard let nowViewController = self.window.rootViewController else {
                    return
                }

                SVProgressHUD.dismiss()
                let popupView = ConfirmationInviteViewBuilder(from: nowViewController)
                    .build(friend: friend, userId: request.userId, friendId: request.friendId, token: request.token, view: nowViewController.view)
                popupView.presentation()
            }, onError: { error in
                SVProgressHUD.dismiss()
                print(error.localizedDescription)
            })
    }
}

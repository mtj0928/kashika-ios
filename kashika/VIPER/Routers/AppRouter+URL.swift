//
//  AppRouter+URL.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/23.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import FirebaseFunctions

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

    private func handleFriendInviteDeeplink(_ url: URL) {
        guard let request = FetchFriendWithToken.Request.parse(url: url) else {
            return
        }

        _ = FetchFriendWithToken.call(request)
            .subscribe(onSuccess: { friend in
                // TODO: - 次はここから実装
                print(friend)
            }, onError: { error in
                print(error)
            })
    }
}

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
            self.handleDeeplink(url)
        }
    }

    private func handleFriendInviteDeeplink(_ url: URL) {
        let component = url.queries["path"]?.split(separator: "/") ?? [String.SubSequence]()
        let userId = String(component[1])
        let friendId = String(component[3])
        guard let token = url.queries["token"] else {
            return
        }
        let request = FetchFriendWithToken.Request(userId: userId, friendId: friendId, token: token)
        FetchFriendWithToken.call(request).subscribe(onSuccess: { friend in
            print(friend)
        }, onError: { error in
            print(error)
        })
    }
}

//
//  AppRouter+URL.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/23.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

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
    }
}

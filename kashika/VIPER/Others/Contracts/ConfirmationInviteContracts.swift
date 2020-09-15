//
//  ConfirmationInviteContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/25.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift

protocol ConfirmationInvitePresenterProtocol {
    var friend: FetchFriendWithToken.FetchedFriend { get }

    func tappedAccept()
    func tappedDeny()
    func tappedLink()
}

protocol ConfirmationInviteInteractorProtocol {
    func accept() -> Completable
    func deny() -> Completable
}

protocol ConfirmationInviteRouterProtocol {
    func dismiss()
    func presentFriendList(for friend: FetchFriendWithToken.FetchedFriend)
}

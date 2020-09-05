//
//  ConfirmationInviteInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/26.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift

struct ConfirmationInviteInteractor: ConfirmationInviteInteractorProtocol {
    
    private let userId: String
    private let friendId: String
    private let token: String

    init(userId: String, friendId: String, token: String) {
        self.userId = userId
        self.friendId = friendId
        self.token = token
    }
    
    func accept() -> Completable {
        let request = ReactionForInvitation.Request(token: token, userId: userId, friendId: friendId, action: .accept)
        return ReactionForInvitation.call(request)
            .asCompletable()
    }
    
    func deny() -> Completable {
        let request = ReactionForInvitation.Request(token: token, userId: userId, friendId: friendId, action: .deny)
        return ReactionForInvitation.call(request)
            .asCompletable()
    }
}

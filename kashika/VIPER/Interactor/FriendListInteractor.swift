//
//  FriendListInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

class FriendListInteractor: FriendListInteractorProtocol {

    var friends: BehaviorRelay<[Friend]> {
        friendsDisposer.behaviorRelay
    }
    private let friendsDisposer: ListenerDisposer<[Friend], DocumentsListener<Friend>>

    init() {
        let documentListener = FriendUseCase().listen({ FriendRequest(user: $0) })
        friendsDisposer = ListenerDisposer(documentListener, { $0.extractData() })
    }
}

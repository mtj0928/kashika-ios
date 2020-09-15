//
//  SelectLinkFriendInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/09/06.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

class SelectLinkFriendInteractor: SimpleFriendListInteractorProtocol {

    let friends = BehaviorRelay<[Friend]>(value: [])

    private let userId: String
    private let friendId: String
    private let token: String

    private let usecase = FriendUseCase(user: UserUseCase().fetchOrCreateUser())
    private let disposeBag = DisposeBag()

    init(userId: String, friendId: String, token: String) {
        self.userId = userId
        self.friendId = friendId
        self.token = token

        usecase.listen { user -> FriendRequest in
            FriendRequest(user: user, isLinked: false)
        }.subscribe(onNext: { [weak self] friends in
            self?.friends.accept(friends)
        }).disposed(by: disposeBag)
    }

    func select(_ friend: Friend) -> Completable {
        let request = ReactionForInvitation.Request(token: token, userId: userId, friendId: friendId, linkedUserId: friend.id, action: .accept)
        return ReactionForInvitation.call(request)
            .asCompletable()
    }
}

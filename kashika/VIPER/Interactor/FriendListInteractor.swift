//
//  FriendListInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class FriendListInteractor: FriendListInteractorProtocol {

    let friends: BehaviorRelay<[Friend]>

    private let friendUseCase: FriendUseCase
    private let disposeBag = DisposeBag()

    init() {
        self.friendUseCase = FriendUseCase(user: UserUseCase().fetchOrCreateUser())
        let observable = friendUseCase.listen({ FriendRequest(user: $0, orders: [Order(key: "name")]) })
            .map { friends in friends.sorted(by: { $0.name < $1.name }) }
        friends = BehaviorRelay.create(observable: observable, initialValue: [], disposeBag: disposeBag)
    }

    func createShardURL(for friend: Friend) -> Single<URL> {
        friendUseCase.createToken(for: friend)
            .flatMap { Self.generateSharedURL(for: friend, token: $0) }
    }

    private static func generateSharedURL(for friend: Friend, token: Token) -> Single<URL> {
        friend.document()
            .flatMap { document in
                let url = Constant.appRootURL?
                    .appendQuery(name: "path", value: document.path)?
                    .appendQuery(name: "token", value: token)
                guard let dynamicLinkComponents = DynamicLinkComponents(link: url!, domainURIPrefix: Constant.pageLinkDomain) else {
                    fatalError("failed creating DynamicLinkComponents")
                }
                return dynamicLinkComponents.ex.shorten()
        }
    }
}

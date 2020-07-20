//
//  FriendUseCase.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/16.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift

class FriendUseCase {

    private let user: Single<User>
    private lazy var repository: Single<FriendRepository> = user.map { FriendRepository(user: $0) }

    init(user: Single<User>) {
        self.user = user
    }

    func create(name: String, icon: UIImage?) -> MonitorObservable<Friend> {
        return repository.asObservable()
            .flatMap { friendRepository in
                return friendRepository.create(name: name, icon: icon)
        }
    }

    func listen(_ requestCreator: @escaping (User) -> FriendRequest) -> Observable<[Friend]> {
        return Single.zip(user.map(requestCreator), repository)
            .asObservable()
            .flatMap { request, repository in
                return repository.listen(request: request)
        }
    }

    func fetch(request: FriendRequest) -> Single<[Friend]> {
        return repository.flatMap { $0.fetch(request: request) }
    }

    func fetch(id: String) -> Single<Friend?> {
        return repository.flatMap { $0.fetch(id: id) }
    }

    func delete(_ friend: Friend) -> Completable {
        return repository.flatMapCompletable { $0.delete(friend) }
    }

    func delete(_ friends: [Friend]) -> Completable {
        return repository.flatMapCompletable { $0.delete(friends) }
    }

    func createToken(for friend: Friend) -> Single<String> {
        if let token = friend.token {
            return Single.just(token)
        }

        var friend = friend
        let token = Token.generate(length: 32)
        friend.token = token
        return repository.flatMap {
            $0.update(friend)
        }.map { _ in token }
    }
}

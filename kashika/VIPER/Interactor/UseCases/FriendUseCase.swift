//
//  FriendUseCase.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/16.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa
import Ballcap

class FriendUseCase {
    let friends = BehaviorRelay<[Friend]>(value: [])

    private let userRepository = UserRepository()
    private let friendRepository = FriendRepository()
    private let disposeBag = RxSwift.DisposeBag()

    init() {
        userRepository
            .fetchOrCreateUser()
            .subscribe(onSuccess: { [weak self] user in
                self?.friendRepository.listen(user: user)
            }).disposed(by: disposeBag)

        friendRepository.friendsObservable
            .subscribe(onNext: { [weak self] documents in
                self?.friends.accept(documents.compactMap({ $0.data }))
            }).disposed(by: disposeBag)
    }

    func fetchFirst(_ filter: @escaping  (Document<Friend>) -> Bool) -> Single<Document<Friend>> {
        return Single.create { [weak self] event -> Disposable in
            guard let first = self?.friendRepository.friends.first(where: filter) else {
                event(.error(NSError(domain: "[mtj0928] Friend is not exists in FriendUseCase", code: -1, userInfo: nil)))
                return Disposables.create()
            }
            event(.success(first))
            return Disposables.create()
        }
    }

    func delete(friends: [Friend]) -> Completable {
        let friendDocuments = self.friendRepository.friends.filter({ document -> Bool in
            return friends.contains(where: { document.data == $0 })
        })
        return friendRepository.deleteFriends(friends: friendDocuments)
    }
}

//
//  UserUseCase.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift

struct UserUseCase {

    private let userRepository = UserRepository()
    private let privateRepository = PrivateUserInformationRepository()
    private let firebaseAuthStore = FirebaseAuthStore()
    private let disposeBag = DisposeBag()

    func fetchOrCreateUser() -> Single<User> {
        if let user = firebaseAuthStore.fetchCurrentUser() {
            return userRepository.fetch(firebaseUser: user)
        }
        return firebaseAuthStore.createUser()
            .flatMap { self.userRepository.create(firebaseUser: $0) }
    }

    func listen() -> Observable<User> {
        fetchOrCreateUser()
            .asObservable()
            .flatMap { self.userRepository.listen(user: $0) }
    }

    func listenPrivate() -> Observable<PrivateUserInformation> {
        fetchOrCreateUser()
            .asObservable()
            .flatMap { self.privateRepository.listen(of: $0) }
    }

    func reset() -> Completable {
        fetchOrCreateUser().flatMapCompletable { user in
            self.privateRepository.reset(of: user)
        }
    }

    func signout() -> Completable {
        userRepository.signout()
    }
}

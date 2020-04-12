//
//  UserRepository.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/16.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift

struct UserRepository {
    
    private let userDataStore = UserDataStore()
    private let firebaseAuthStore = FirebaseAuthStore()
    
    func create(firebaseUser: FirebaseUser) -> Single<User> {
        return userDataStore.create(authId: firebaseUser.uid)
            .map { $0.data! }
    }
    
    func fetch(firebaseUser: FirebaseUser) -> Single<User> {
        return userDataStore.fetch(authId: firebaseUser.uid)
            .map { $0.data! }
    }
    
    func listen(user: User) -> Observable<User> {
        return user.document().asObservable()
            .flatMap { userDoument  in
                self.userDataStore.listen(userDoument)
        }.map { $0.data! }
    }

    func reset(user: User) -> Completable {
        return user.document()
            .flatMap { user -> Single<User> in
                user.data?.totalDebt = 0
                return self.userDataStore.save(user: user)
                    .map { $0.data! }
        }.asCompletable()
    }
    
    func signout() -> Completable {
        return firebaseAuthStore.signout()
    }
}

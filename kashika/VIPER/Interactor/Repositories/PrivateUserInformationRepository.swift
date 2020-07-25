//
//  PrivateUserInformationRepository.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/25.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import Ballcap
import RxSwift

struct PrivateUserInformationRepository {

    private let dataStore = PrivateUserInformationDataStore()

    func create(for user: User) -> Single<PrivateUserInformation> {
        user.document()
            .flatMap { self.dataStore.create(for: $0) }
            .map { $0.data! }
    }

    func fetch(of user: User) -> Single<PrivateUserInformation> {
        user.document()
            .flatMap { self.dataStore.fetch(of: $0) }
            .map { $0.data! }
    }

    func listen(of user: User) -> Observable<PrivateUserInformation> {
        user.document()
            .asObservable()
            .flatMap { self.dataStore.listen(of: $0) }
            .map { $0.data! }
    }

    func delete(of user: User) -> Completable {
        user.document()
            .flatMap { self.dataStore.fetch(of: $0) }
            .flatMapCompletable { self.dataStore.delete($0) }
    }

    func reset(of user: User) -> Completable {
        user.document()
            .flatMap { self.dataStore.fetch(of: $0) }
            .flatMap { (document: Document<PrivateUserInformation>) -> Single<Document<PrivateUserInformation>> in
                document.data?.totalDebt = 0
                return self.dataStore.update(document)
        }.asCompletable()
    }
}

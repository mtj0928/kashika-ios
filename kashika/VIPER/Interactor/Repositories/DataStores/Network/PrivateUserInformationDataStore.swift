//
//  PrivateUserInfomationDataStore.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/25.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import Ballcap
import RxSwift

struct PrivateUserInformationDataStore {

    func create(for user: Document<User>) -> Single<Document<PrivateUserInformation>> {
        Single<Document<PrivateUserInformation>>.create { observer in
            let document = self.createDocument(for: user)
            document.data = PrivateUserInformation()
            document.data?.id = user.id

            observer(.success(document))

            return Disposables.create()
        }.flatMap { document in
            document.ex.save()
        }
    }

    func fetch(of user: Document<User>) -> Single<Document<PrivateUserInformation>> {
        createDocument(for: user).ex.get()
    }

    func listen(of user: Document<User>) -> Observable<Document<PrivateUserInformation>> {
        createDocument(for: user).ex.get()
            .asObservable()
            .flatMap { $0.listen() }
    }

    func update(_ document: Document<PrivateUserInformation>) -> Single<Document<PrivateUserInformation>> {
        document.ex.update()
    }

    func delete(_ document: Document<PrivateUserInformation>) -> Completable {
        document.ex.delete()
    }
}

extension PrivateUserInformationDataStore {

    private func createDocument(for user: Document<User>) -> Document<PrivateUserInformation> {
        let id = user.id
        let reference = user.documentReference.collection("secure").document(id)
        return Document<PrivateUserInformation>(reference)
    }
}

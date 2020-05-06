//
//  FriendDataStore.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/11.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import UIKit
import Ballcap
import FirebaseFirestore
import FirebaseStorage

struct FriendDataStore: DocumentOperatorSet {
    typealias Request = FriendRequest

    static let imageMinLength: CGFloat = 200
    static let fileName = "icon"

    let collectionReference: CollectionReference?
    private let userId: String

    init(user: Document<User>) {
        userId = user.id
        self.collectionReference = user.documentReference.collection(Friend.collectionName)
    }

    init(userId: String) {
        self.userId = userId
        self.collectionReference = Document<User>(id: userId).documentReference.collection(Friend.collectionName)
    }

    func create(name: String, icon: UIImage?) -> MonitorObservable<Document<Friend>> {
        return Observable.just(createFriend(name: name, icon: icon))
            .flatMap({ (document: Document<Friend>) -> Observable<(Document<Friend>, Monitor<StorageMetadata?>)> in
                guard let data = document.data else {
                    return Observable.error(NSError(domain: "[mtj0928] Document.data is not exist", code: -1, userInfo: nil))

                }
                return Observable.combineLatest(Observable.just(document), data.iconFile?.ex.save() ?? Observable.just(Monitor(nil)))
            })
            .map { (document, monitor) in monitor.map { _ in document } }
            .do(onNext: { (monitor: Monitor<Document<Friend>>) in
                if let value = monitor.value {
                    value.save()
                }
            })
    }

    private func createFriend(name: String, icon: UIImage?) -> Document<Friend> {
        let document = Document<Friend>(collectionReference: collectionReference)
        let reference = document.storageReference.child(FriendDataStore.fileName)
        let data = icon?.resize(minLength: FriendDataStore.imageMinLength)?.pngData()
        let file = File(reference, data: data, mimeType: .png)

        document.data?.userId = userId
        document.data?.name = name
        document.data?.iconFile = file
        document.data?.id = document.id

        return document
    }

    func delete(_ documents: [Document<Friend>]) -> Completable {
        return StorageBatch.ex.commit { batch in
            let iconFiles = documents.compactMap { $0.data?.iconFile }
            batch.delete(iconFiles)
        }
        .andThen(Batch.ex.commit { batch in
            documents.forEach { document in
                batch.delete(document)
            }
        })
    }
}

struct FriendRequest: Request {

    typealias Model = Friend

    let user: User
    var debtType: DebtType?
    var orders: [Order] = []
    var limit: Int?
    var after: Document<Friend>?

    var collectionReference: CollectionReference {
        Document<User>(id: user.id).documentReference.collection(Friend.collectionName)
    }

    func query(_ query: Self.Query) -> Self.Query {
        var query = query
        query = debtType(query)

        orders.forEach { order in
            query = query.order(by: order.key, descending: order.descending)
        }

        if let limit = limit {
            query = query.limit(to: limit)
        }

        if let snapshot = after?.snapshot {
            query = query.start(afterDocument: snapshot)
        }

        return query
    }

    private func debtType(_ query: Self.Query) -> Self.Query {
        switch debtType {
        case .kari:
            return query.where("totalDebt", isGreaterThan: 0)
        case .kashi:
            return query.where("totalDebt", isLessThan: 0)
        case .some(.none):
                break
        case .none:
            break
        }
        return query
    }
}

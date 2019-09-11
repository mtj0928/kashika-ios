//
//  FriendDataStore.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import Ballcap
import Firebase

struct FriendDataStore {

    static let key = "friends"
    static let imageMinLength: CGFloat = 200
    static let fileName = "icon"

    func create(user userDocument: Document<User>, name: String, icon: UIImage?) -> MonitorObservable<Document<Friend>> {
        return Observable.just(userDocument)
            .map({ userDocument in
                let collectionReference = userDocument.documentReference.collection(FriendDataStore.key)
                let document = Document<Friend>(collectionReference: collectionReference)
                let reference = document.storageReference.child(FriendDataStore.fileName)
                let data = icon?.resize(minLength: FriendDataStore.imageMinLength)?.pngData()
                let file = File(reference, data: data, mimeType: .png)

                document.data?.name = name
                document.data?.iconFile = file
                document.data?.id = document.id

                return document
            })
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

    func listen(user userDocument: Document<User>) -> DataSource<Document<Friend>> {
        let reference = userDocument.documentReference.collection(FriendDataStore.key)
        let query = DataSource<Document<Friend>>.Query(reference)
        let dataSource = DataSource(reference: query).retrieve { (_, documentSnapshot, done) in
            let document = Document<Friend>(documentSnapshot.reference)
            document.get { (document, _) in
                // swiftlint:disable:next force_unwrapping
                done(document!)
            }
        }
        return dataSource
    }

    func delete(_ friends: [Document<Friend>]) -> Completable {
        return StorageBatch.ex.commit { batch in
            batch.delete(friends.compactMap({ $0.data?.iconFile }))
        }.andThen(Batch.ex.commit({ (batch) in
            friends.forEach { batch.delete($0) }
        }))
    }
}

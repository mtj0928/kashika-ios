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
        return Observable.create { observer -> Disposable in
            let collectionReference = userDocument.documentReference.collection(FriendDataStore.key)
            let friendDocument = Document<Friend>(collectionReference: collectionReference)

            friendDocument.data?.name = name

            let reference = Storage.storage().reference(withPath: friendDocument.path).child(FriendDataStore.fileName)
            let data = icon?.resize(minLength: FriendDataStore.imageMinLength)?.pngData()
            let file = File(reference, data: data, mimeType: .png)

            let saveHandler = { () -> (Document<Friend>) in
                friendDocument.data?.iconFile = file
                friendDocument.save()
                return friendDocument
            }

            return file.ex.save()
                .map({ $0.map { _ in saveHandler() } })
                .subscribe(onNext: observer.onNext, onError: observer.onError, onCompleted: observer.onCompleted)
        }
    }

    func listen(user userDocument: Document<User>) -> Observable<[Document<Friend>]> {
        return Observable.create { observer -> Disposable in
            let reference = userDocument.documentReference.collection(FriendDataStore.key)
            let listner = reference.addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let snapshot = querySnapshot else {
                    observer.onCompleted()
                    return
                }
                let documents = snapshot.documents
                    .map { Document<Friend>(snapshot: $0) }
                    .compactMap { $0 }
                observer.onNext(documents)
            }
            return Disposables.create {
                listner.remove()
            }
        }
    }

    func delete(_ friends: [Document<Friend>]) -> Completable {
        return StorageBatch.ex.commit { batch in
            batch.delete(friends.compactMap({ $0.data?.iconFile }))
        }.andThen(Batch.ex.commit({ (batch) in
            friends.forEach { batch.delete($0) }
        }))
    }
}

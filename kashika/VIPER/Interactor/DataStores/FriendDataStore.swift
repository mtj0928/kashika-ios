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

    func create(user userDocument: Document<User>, name: String, icon: UIImage?) -> MonitorObservable<Document<Friend>> {
        return Observable.create { observer -> Disposable in
            let collectionReference = userDocument.documentReference.collection(FriendDataStore.key)
            let friendDocument = Document<Friend>(collectionReference: collectionReference)

            friendDocument.data?.name = name
            if icon == nil {
                friendDocument.save()
                observer.onNext(Monitor(friendDocument))
                return Disposables.create()
            }

            let reference = Storage.storage().reference(withPath: friendDocument.path).child("icon")
            let data = icon?.pngData()
            let file = File(reference, data: data, mimeType: .png)

            let saveHandler = { () -> (Document<Friend>) in
                friendDocument.data?.iconFile = file
                friendDocument.save()
                return friendDocument
            }

            return file.save()
                .map({ $0.map { _ -> (Document<Friend>) in saveHandler() } })
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
}

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

    func create(user userDocument: Document<User>, name: String, icon: UIImage?) -> Single<Document<Friend>> {
        return Single.create { observer -> Disposable in
            let collectionReference = userDocument.documentReference.collection(FriendDataStore.key)
            let friendDocument = Document<Friend>(collectionReference: collectionReference)

            friendDocument.data?.name = name
            let reference = Storage.storage().reference(withPath: friendDocument.path).child("icon")
            let data = icon?.pngData()
            let file = File(reference, data: data, mimeType: .png)
            let disposable = file.save().subscribe(onSuccess: { _ in
                friendDocument.data?.iconFile = file
                friendDocument.save()
                observer(.success(friendDocument))
            }, onError: { observer(.error($0)) })

            return disposable
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

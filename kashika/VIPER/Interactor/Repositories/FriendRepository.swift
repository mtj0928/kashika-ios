//
//  FriendRepository.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/09.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import Ballcap
import RxSwift
import FirebaseStorage

struct FriendRepository {

    static let key = "friends"
    static let imageMinLength: CGFloat = 200
    static let fileName = "icon"

    func create(user userDocument: Document<User>, name: String, icon: UIImage?) -> MonitorObservable<Document<Friend>> {
        return Observable.just(createFriend(user: userDocument, name: name, icon: icon))
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

    private func createFriend(user userDocument: Document<User>, name: String, icon: UIImage?) -> Document<Friend> {
        let collectionReference = userDocument.documentReference.collection(FriendRepository.key)
        let document = Document<Friend>(collectionReference: collectionReference)
        let reference = document.storageReference.child(FriendRepository.fileName)
        let data = icon?.resize(minLength: FriendRepository.imageMinLength)?.pngData()
        let file = File(reference, data: data, mimeType: .png)

        document.data?.name = name
        document.data?.iconFile = file
        document.data?.id = document.id

        return document
    }
}

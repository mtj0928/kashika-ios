//
//  File+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/18.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Ballcap
import FirebaseStorage
import RxSwift

extension File {

    func save() -> MonitorObservable<StorageMetadata> {
        return Observable.create { [weak self] observer -> Disposable in
            let task = self?.save { (metadata, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                if let metadata = metadata {
                    observer.onNext(Monitor(metadata))
                    return
                }

                observer.onError(NSError(domain: "[mtj0928] cannot save file", code: -1, userInfo: nil))
            }
            let handler = task?.observe(.progress, handler: { snapshot in
                guard let progress = snapshot.progress else {
                    return
                }
                observer.onNext(Monitor(progress))
            })
            return Disposables.create {
                if let handler = handler {
                    task?.removeObserver(withHandle: handler)
                }
                task?.cancel()
            }
        }
    }
}

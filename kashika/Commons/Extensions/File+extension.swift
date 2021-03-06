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

extension File: TargetedExtensionCompatible {
}

extension TargetedExtension where Base: File {

    func save() -> MonitorObservable<StorageMetadata?> {
        return Observable.create { observer -> Disposable in
            guard self.base.data != nil else {
                observer.onNext(Monitor(nil))
                observer.onCompleted()
                return Disposables.create()
            }

            let task = self.base.save { (metadata, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onNext(Monitor(metadata))
                observer.onCompleted()
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

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

    func save() -> Single<StorageMetadata> {
        return Single.create { [weak self] event -> Disposable in
            let task = self?.save { (metadata, error) in
                if let error = error {
                    event(.error(error))
                    return
                }
                if let metadata = metadata {
                    event(.success(metadata))
                    return
                }
                event(.error(NSError(domain: "[mtj0928] cannot save file", code: -1, userInfo: nil)))
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}

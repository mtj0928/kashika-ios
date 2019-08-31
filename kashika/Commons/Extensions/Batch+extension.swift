//
//  Batch+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import Ballcap

extension Batch: TargetedExtensionCompatible {
}

extension TargetedExtension where Base: Batch {

    static func commit(_ handler: @escaping (Batch) -> Void) -> Completable {
        return Completable.create { event -> Disposable in
            let batch = Batch()
            handler(batch)
            batch.commit { error in
                if let error = error {
                    event(.error(error))
                } else {
                    event(.completed)
                }
            }
            return Disposables.create()
        }
    }
}

extension StorageBatch: TargetedExtensionCompatible {
}

extension TargetedExtension where Base: StorageBatch {

    static func commit(_ handler: @escaping (StorageBatch) -> Void) -> Completable {
        return Completable.create { event -> Disposable in
            let batch = StorageBatch()
            handler(batch)
            batch.commit { error in
                if let error = error {
                    event(.error(error))
                } else {
                    event(.completed)
                }
            }
            return Disposables.create()
        }
    }
}

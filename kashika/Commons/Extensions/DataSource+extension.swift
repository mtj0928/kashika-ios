//
//  DataSource+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/10/22.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import Ballcap

extension DataSource.Query: TargetedExtensionCompatible {

}

extension TargetedExtension {

    func get<Model>() -> Single<[Document<Model>]> where Base: DataSource<Document<Model>>.Query {
        return Single.create { event in
            self.base.get { (querySnapshot, error) in
                guard let querySnapshot = querySnapshot else {
                    if let error = error {
                        event(.error(error))
                    } else {
                        event(.error(NSError(domain: "Unexpected error", code: -1, userInfo: nil)))
                    }
                    return
                }
                let documents = querySnapshot.documents
                    .compactMap({ Document<Model>(snapshot: $0) })
                event(.success(documents))
            }
            return Disposables.create()
        }
    }

}

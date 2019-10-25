//
//  Document+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//
import Ballcap
import FirebaseStorage
import RxSwift

extension Document: TargetedExtensionCompatible {
}

extension TargetedExtension {

    func save<Model: Modelable & Codable>() -> Single<Document<Model>> where Base: Document<Model> {
        return Single.create { event -> Disposable in
            self.base.save { error in
                if let error = error {
                    event(.error(error))
                } else {
                    event(.success(self.base))
                }
            }
            return Disposables.create()
        }
    }

    func get<Model: Modelable & Codable>() -> Single<Document<Model>> where Base: Document<Model> {
        return Single.create { event -> Disposable in
            self.base.get { (document, error) in
                if let error = error {
                    event(.error(error))
                }
                if let document = document {
                    event(.success(document))
                }
            }
            return Disposables.create()
        }
    }

    func update<Model: Modelable & Codable>() -> Single<Document<Model>> where Base: Document<Model> {
        return Single.create { event -> Disposable in
            self.base.update { error in
                if let error = error {
                    event(.error(error))
                } else {
                    event(.success(self.base))
                }
            }
            return Disposables.create()
        }
    }

    func delete<Model: Modelable & Codable>() -> Completable where Base: Document<Model> {
        return Completable.create { event -> Disposable in
            self.base.delete { error in
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

extension Array {

    func extractData<Model: Modelable & Codable>() -> [Model] where Element: Document<Model> {
        return self.compactMap({ document in
            document.data
        })
    }
}

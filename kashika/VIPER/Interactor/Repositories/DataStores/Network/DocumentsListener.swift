//
//  DocumentListener.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/10/22.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import Ballcap
import RxSwift
import RxCocoa
import FirebaseFirestore

extension Document {

    func listen() -> Observable<Document<Model>> {
        return Observable<Document<Model>>.create { [weak self] event in
            guard let id = self?.id else {
                return Disposables.create()
            }
            let disposer = Document<Model>.listen(id: id) { (document, error) in
                if let error = error {
                    event.on(.error(error))
                }
                if let document = document {
                    event.on(.next(document))
                }
            }
            return Disposables.create {
                disposer.dispose()
            }
        }
    }

    static func listen<Request: kashika.Request>(_ request: Request) -> Observable<[Document<Model>]> where Request.Model == Model {
        Single.just(request)
            .map({ $0.resolve().dataSource() })
            .asObservable()
            .flatMap { dataSource in
                Observable<[Document<Model>]>.create { observer -> Disposable in
                    let dataSource = dataSource.retrieve { (_, documentSnapshot, done) in
                        guard let document = try? Document<Model>(snapshot: documentSnapshot) else {
                            return
                        }
                        done(document)
                    }.onChanged { (_, dataSourceSnapshot) in
                        observer.on(.next(dataSourceSnapshot.after))
                    }.sorted { (_, _) in
                        return true
                    }.listen()
                    return Disposables.create {
                        dataSource.stop()
                    }
                }
        }
    }
}

extension BehaviorRelay {

    static func create(observable: Observable<Element>, initialValue value: Element, disposeBag: RxSwift.DisposeBag) -> BehaviorRelay<Element> {
        let beviorRelay = BehaviorRelay(value: value)
        observable.subscribe(onNext: { element in
            beviorRelay.accept(element)
        }).disposed(by: disposeBag)
        return beviorRelay
    }
}

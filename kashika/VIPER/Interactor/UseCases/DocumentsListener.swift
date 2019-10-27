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
/*
 protocol Listener {
 associatedtype Element

 var obserbavle: Observable<Element> { get }
 var value: Element { get }

 func stop()
 }

 class DocumentListener<Model: Codable & Modelable>: Listener {

 typealias Element = Document<Model>?

 var obserbavle: Observable<Document<Model>?> {
 return behaviorSubject
 }
 var value: Document<Model>? {
 return (try? behaviorSubject.value())
 }

 private let behaviorSubject = BehaviorSubject<Document<Model>?>(value: nil)
 private let rxDisposeBag = RxSwift.DisposeBag()
 private let disposeBag = Ballcap.DisposeBag()

 fileprivate init(_ document: Single<Document<Model>>) {
 document.subscribe(onSuccess: { [weak self] document in
 guard let disposeBag = self?.disposeBag else {
 return
 }
 document.listen { (document, error) in
 if error != nil {
 self?.behaviorSubject.onNext(nil)
 return
 }
 self?.behaviorSubject.onNext(document)
 }.disposed(by: disposeBag)
 }).disposed(by: rxDisposeBag)
 }

 func stop() {
 }

 func map<T>(_ mapper: @escaping (Element) -> T) -> ListenerDisposer<T, DocumentListener<Model>> {
 return ListenerDisposer(self, mapper)
 }
 }

 class DocumentsListener<Model: Codable & Modelable>: Listener {

 typealias Element = [Document<Model>]

 var obserbavle: Observable<[Document<Model>]> {
 return behaviorSubject
 }
 var value: [Document<Model>] {
 return (try? behaviorSubject.value()) ?? []
 }

 private let behaviorSubject = BehaviorSubject<[Document<Model>]>(value: [])
 private var dataSource: DataSource<Document<Model>>?
 private var disposeBag = RxSwift.DisposeBag()

 fileprivate init(_ dataSource: Single<DataSource<Document<Model>>>) {
 dataSource.subscribe(onSuccess: { [weak self] dataSource in
 self?.dataSource = dataSource.retrieve { (_, documentSnapshot, done) in
 let document = Document<Model>(documentSnapshot.reference)
 document.get { (document, _) in
 if let document = document {
 done(document)
 }
 }
 }.onChanged { [weak self] (_, dataSourceSnapshot) in
 self?.behaviorSubject.onNext(dataSourceSnapshot.after)
 }.listen()
 }).disposed(by: disposeBag)
 }

 deinit {
 dataSource?.stop()
 }

 func stop() {
 dataSource?.stop()
 dataSource = nil
 disposeBag = RxSwift.DisposeBag()
 }
 }

 extension Document {

 static func listen<Request: kashika.Request>(_ request: Single<Request>) -> DocumentsListener<Model> where Request.Model == Model {
 let dataSource = request.map({ $0.resolve() })
 .map({ $0.dataSource() })
 return DocumentsListener<Model>(dataSource)
 }

 static func listen(_ single: Single<Document<Model>>) -> DocumentListener<Model> {
 return DocumentListener<Model>(single)
 }

 static func listen<Request: kashika.Request>(_ request: Request) -> Observable<[Document<Model>]> where Request.Model == Model {
 Single.just(request)
 .map({ $0.resolve().dataSource() })
 .asObservable()
 .flatMap { dataSource in
 Observable<[Document<Model>]>.create { observer -> Disposable in
 let dataSource = dataSource.retrieve { (_, documentSnapshot, done) in
 let document = Document<Model>(documentSnapshot.reference)
 document.get { (document, _) in
 if let document = document {
 done(document)
 }
 }
 }.onChanged { (_, dataSourceSnapshot) in
 observer.on(.next(dataSourceSnapshot.after))
 }.listen()
 return Disposables.create {
 dataSource.stop()
 }
 }
 }
 }
 }
 */

extension Document {

    func listen() -> Observable<Document<Model>> {
        Single.just(self).asObservable()
            .flatMap { (document: Document<Model>) in
                return Observable<Document<Model>>.create { event in
                    document.get { (doc, error) in
                        if let error = error {
                            event.on(.error(error))
                        }
                        if let doc = doc {
                            event.on(.next(doc))
                        }
                    }
                    let disposer = document.listen { (document, error) in
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
    }

    static func listen<Request: kashika.Request>(_ request: Request) -> Observable<[Document<Model>]> where Request.Model == Model {
        Single.just(request)
            .map({ $0.resolve().dataSource() })
            .asObservable()
            .flatMap { dataSource in
                Observable<[Document<Model>]>.create { observer -> Disposable in
                    let dataSource = dataSource.retrieve { (_, documentSnapshot, done) in
                        if let document = Document<Model>(snapshot: documentSnapshot) {
                            done(document)
                        }
                    }.onChanged { (_, dataSourceSnapshot) in
                        observer.on(.next(dataSourceSnapshot.after))
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

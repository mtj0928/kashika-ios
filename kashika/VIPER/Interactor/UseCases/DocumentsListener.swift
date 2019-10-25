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

protocol Listener {
    associatedtype Element

    var obserbavle: Observable<Element> { get }
    var value: Element { get }

    func stop()
}

class DocumentListener<Model: Codable & Modelable>: Listener {

    typealias Element = Document<Model>?

    var obserbavle: Observable<Document<Model>?> {
        return publishSubject
    }
    var value: Document<Model>? {
        return (try? publishSubject.value())
    }

    private let publishSubject = BehaviorSubject<Document<Model>?>(value: nil)
    private let rxDisposeBag = RxSwift.DisposeBag()
    private let disposeBag = Ballcap.DisposeBag()

    fileprivate init(_ document: Single<Document<Model>>) {
        document.subscribe(onSuccess: { [weak self] document in
            guard let disposeBag = self?.disposeBag else {
                return
            }
            document.listen { (document, error) in
                if error != nil {
                    self?.publishSubject.onNext(nil)
                    return
                }
                self?.publishSubject.onNext(document)
            }.disposed(by: disposeBag)
        }).disposed(by: rxDisposeBag)
    }

    func stop() {
    }
}

class DocumentsListener<Model: Codable & Modelable>: Listener {

    typealias Element = [Document<Model>]

    var obserbavle: Observable<[Document<Model>]> {
        return publishSubject
    }
    var value: [Document<Model>] {
        return (try? publishSubject.value()) ?? []
    }

    private let publishSubject = BehaviorSubject<[Document<Model>]>(value: [])
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
                self?.publishSubject.onNext(dataSourceSnapshot.after)
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
}

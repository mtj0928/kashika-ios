//
//  DocumentOperator.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/10/22.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Ballcap
import RxSwift
import FirebaseFirestore

protocol DocumentOperator {
    associatedtype Request: kashika.Request
    typealias Model = Request.Model

    var collectionReference: Single<CollectionReference?> { get }
}

extension DocumentOperator {

    var collectionReference: Single<CollectionReference?> {
        Single.just(nil)
    }
}

// MARK: - DocumentCreator

protocol DocumentCreator: DocumentOperator {
}

extension DocumentCreator {
    func save(_ document: Document<Model>) -> Single<Document<Model>> {
        return document.ex.save()
    }
}

// MARK: - DocumentFetcher

protocol DocumentFetcher: DocumentOperator {
}

extension DocumentFetcher {

    func fetch(id: String) -> Single<Document<Model>> {
        return collectionReference.flatMap { reference in
            Document<Model>(id: id, collectionReference: reference).ex.get()
        }
    }

    func fetch(request: Request) -> Single<[Document<Model>]> {
        let query = request.resolve()
        return query.ex.get()
    }
}

// MARK: - DocumentUpdater

protocol DocumentUpdater: DocumentOperator {
}

extension DocumentUpdater {
    func update(_ document: Document<Model>) -> Single<Document<Model>> {
        return update([document]).map({ $0[0] })
    }

    func update(_ documents: [Document<Model>]) -> Single<[Document<Model>]> {
        return Batch.ex.commit({ batch in
            documents.forEach({ batch.update($0) })
        }).andThen(Single.just(documents))
    }
}

// MARK: - DocumentDeleter

protocol DocumentDeleter: DocumentOperator {
}

extension DocumentDeleter {
    func delete(_ document: Document<Model>) -> Completable {
        return delete([document])
    }

    func delete(_ documents: [Document<Model>]) -> Completable {
        return Batch.ex.commit { batch in
            documents.forEach({ batch.delete($0) })
        }
    }
}

// MARK: - DocumentOperatorSet

protocol DocumentOperatorSet: DocumentCreator, DocumentDeleter, DocumentFetcher, DocumentUpdater {
}

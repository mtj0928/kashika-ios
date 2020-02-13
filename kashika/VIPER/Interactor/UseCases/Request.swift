//
//  Request.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/10/22.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import Ballcap
import FirebaseFirestore

struct Order {
    let key: String
    var descending = false
}

protocol Request {
    associatedtype Model: Modelable, Codable

    typealias Query = DataSource<Document<Model>>.Query

    var orders: [Order] { get }
    var limit: Int? { get }
    var after: Document<Model>? { get }
    var collectionReference: CollectionReference { get }

    func resolve(_ query: Query) -> Query
}

extension Request {

    func resolve() -> Query {
        var query = Query(collectionReference)

        query = resolve(query)

        orders.forEach { order in
            query = query.order(by: order.key, descending: order.descending)
        }

        if let limit = limit {
            query = query.limit(to: limit)
        }

        if let snapshot = after?.snapshot {
            query = query.start(afterDocument: snapshot)
        }

        return query
    }
}

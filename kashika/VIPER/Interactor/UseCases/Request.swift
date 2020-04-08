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

    var collectionReference: CollectionReference { get }

    func query(_ query: Query) -> Query
}

extension Request {

    func resolve() -> Query {
        query(Query(collectionReference))
    }
}

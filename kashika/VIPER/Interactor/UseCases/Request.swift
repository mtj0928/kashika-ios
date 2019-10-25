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

protocol Request {
    associatedtype Model: Modelable, Codable

    var collectionReference: CollectionReference { get }

    func resolve() -> DataSource<Document<Model>>.Query
}

struct Order {
    let key: String
    var descending = false
}

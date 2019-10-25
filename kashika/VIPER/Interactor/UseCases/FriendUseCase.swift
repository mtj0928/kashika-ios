//
//  FriendUseCase.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/16.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa
import Ballcap
import FirebaseFirestore

class FriendUseCase: DocumentOperatorSet {
    typealias Request = FriendRequest

    func listen(_ requestCreator: @escaping (Document<User>) -> FriendRequest) -> DocumentsListener<Friend> {
        let request = UserUseCase().fetchOrCreateUser()
            .map(requestCreator)
        return Document.listen(request)
    }
}

struct FriendRequest: Request {

    typealias Model = Friend

    static let key = "friends"

    let user: Document<User>
    var debtType: DebtType?
    var orders: [Order] = []
    var limit: Int?
    var after: Document<Friend>?

    var collectionReference: CollectionReference {
        user.documentReference.collection(FriendRequest.key)
    }

    func resolve() -> DataSource<Document<Friend>>.Query {
        var query = DataSource<Document<Friend>>.Query(collectionReference)

        query = .kashi == debtType ? query.where("totalDebt", isGreaterThan: 0)
            : .kari == debtType ? query.where("totalDebt", isLessThan: 0)
            : query

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

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

    private static let key = "friends"

    private var _collectioeference: CollectionReference?
    var collectionReference: Single<CollectionReference?> {
        getCollectionReference()
    }

    func listen(_ requestCreator: @escaping (Document<User>) -> FriendRequest) -> Observable<[Document<Friend>]> {
        return UserUseCase().fetchOrCreateUser()
            .map(requestCreator)
            .asObservable()
            .flatMap({ Document<Friend>.listen($0) })
    }

    private func getCollectionReference() -> Single<CollectionReference?> {
        if let reference = _collectioeference {
            return Single.just(reference)
        }
        return UserUseCase().fetchOrCreateUser().map { user in
            user.documentReference.collection(FriendUseCase.key)
        }.do(onSuccess: {[weak self] ref in
            self?._collectioeference = ref
        })
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

    func resolve(_ query: Self.Query) -> Self.Query {
        var query = query
        switch debtType {
        case .kari:
            query = query.where("totalDebt", isGreaterThan: 0)
        case .kashi:
            query = query.where("totalDebt", isLessThan: 0)
        case .none:
            break
        }
        return query
    }
}

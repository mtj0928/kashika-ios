//
//  DebtDataStore.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import Ballcap
import Firebase

struct DebtDataStore: DocumentOperatorSet {

    typealias Request = DebtRequest

    // swiftlint:disable:next function_parameter_count
    func create(owner user: Document<User>, money: Int, friends: [Document<Friend>], paymentDate: Date?, memo: String?, type: DebtType) -> Single<[Document<Debt>]> {
        let money = type == .kari ? money : -money
        return Single.just(friends)
            .flatMap { (friends) in
                let debts = friends.map({ friend -> Document<Debt> in
                    let collectionReference = user.documentReference.collection(Debt.collectionName)
                    let document = Document<Debt>(collectionReference: collectionReference)
                    document.data = Debt(id: document.id, userId: user.id, money: money, friendId: friend.id, paymentDate: paymentDate?.ex.asTimestamp(), memo: memo, isPaid: false)
                    return document
                })
                friends.forEach { friend in
                    friend.data?.totalDebt = .increment(Int64(money))
                }
                user.data?.totalDebt = .increment(Int64(money * friends.count))
                return Batch.ex.commit { batch in
                    debts.forEach { batch.save($0) }
                    friends.forEach { batch.update($0) }
                    batch.update(user)
                }.andThen(Single.just(debts))
        }
    }

    func listen(user userDocument: Document<User>) -> Observable<[Document<Debt>]> {
        return Observable.create { emitter -> Disposable in
            let reference = userDocument.documentReference.collection(Debt.collectionName)
            let query = DataSource<Document<Debt>>.Query(reference)
            let dataSource = DataSource(reference: query).retrieve { (_, documentSnapshot, done) in
                let document = Document<Debt>(documentSnapshot.reference)
                _ = document.get { (document, error) in
                    if let document = document {
                        done(document)
                    }
                    if let error = error {
                        print(error.localizedDescription)
                        done(nil)
                    }
                }
            }.onChanged { (_, snapshot) in
                emitter.onNext(snapshot.after)
            }.listen()

            return Disposables.create {
                dataSource.stop()
            }
        }
    }
}

struct DebtRequest: Request {

    typealias Model = Debt

    let user: User
    var orders: [Order] = []
    var predicates: [NSPredicate] = []

    var collectionReference: CollectionReference {
        Document<User>(id: user.id).documentReference.collection(Debt.collectionName)
    }

    func query(_ query: Self.Query) -> Self.Query {
        var query = query
        orders.forEach { order in
            query = query.order(by: order.key, descending: order.descending)
        }
        predicates.forEach { predicate in
            query = query.filter(using: predicate)
        }
        return query
    }
}

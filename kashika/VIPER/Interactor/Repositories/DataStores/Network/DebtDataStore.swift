//
//  DebtDataStore.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import Ballcap

struct DebtDataStore {

    static let key = "debts"

    func create(money: Int, friendDocuemnt: Document<Friend>, userDocument: Document<User>) -> Single<Document<Debt>> {
        return Single.just(userDocument)
            .map({ userDocument -> Document<Debt> in
                let collectionReference = userDocument.documentReference.collection(DebtDataStore.key)
                let debtDocument = Document<Debt>(collectionReference: collectionReference)

                debtDocument.data?.money = money
                debtDocument.data?.friendRef = friendDocuemnt.documentReference
                friendDocuemnt.data?.totalDebt = .increment(Int64(money))

                return debtDocument
        }).flatMap({ debt in
            Batch.ex.commit { batch in
                batch.update(friendDocuemnt)
                batch.save(debt)
            }.andThen(Single.just(debt))
        })
    }
}

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

    func create(debt: UnstoredDebt, userDocument: Document<User>) -> Single<Document<Debt>> {
        return create(debts: [debt], userDocument: userDocument).map({ $0[0] })
    }

    func create(debts: [UnstoredDebt], userDocument: Document<User>) -> Single<[Document<Debt>]> {
        return Single.just(userDocument)
            .map({ userDocument -> [(Document<Debt>, Document<Friend>, Document<User>)] in
                return debts.map({ debt in
                    let collectionReference = userDocument.documentReference.collection(DebtDataStore.key)
                    let debtDocument = Document<Debt>(collectionReference: collectionReference)
                    let friendDocument: Document<Friend>! = debt.document

                    debtDocument.data?.money = debt.money
                    debtDocument.data?.friendId = debt.document?.id
                    debtDocument.data?.paymentDate = debt.paymentDate
                    friendDocument?.data?.totalDebt = .increment(Int64(debt.money))
                    userDocument.data?.totalDebt = .increment(Int64(debt.money))

                    return (debtDocument, friendDocument, userDocument)
                })
            }).flatMap({ debts in
                Batch.ex.commit { batch in
                    debts.forEach { debt in
                        batch.save(debt.0)
                        batch.update(debt.1)
                        batch.update(debt.2)
                    }
                }.andThen(Single.just(debts.map({ $0.0 })))
            })
    }
}

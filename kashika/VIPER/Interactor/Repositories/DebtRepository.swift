//
//  DebtRepository.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import Ballcap
import RxSwift

struct DebtRepository {
    typealias Request = DebtRequest

    private let userRepository = UserRepository()
    private let debtDataStore = DebtDataStore()
    private let disposeBag = RxSwift.DisposeBag()

    // swiftlint:disable:next function_parameter_count
    func create(owner user: User, money: Int, friends: [Friend], paymentDate: Date?, memo: String?, type: DebtType) -> Single<[Debt]> {
        let documents = friends.map { $0.document() }
        return Single.zip(user.document(), Single.zip(documents))
            .flatMap { (user, friendDocuments) -> Single<[Document<Debt>]> in
                self.debtDataStore.create(owner: user, money: money, friends: friendDocuments, paymentDate: paymentDate, memo: memo, type: type)
        }.map { $0.extractData() }
    }

    func fetch(request: DebtRequest) -> Single<[Debt]> {
        return debtDataStore.fetch(request: request)
            .map { $0.extractData() }
    }

    func delete(_ debts: [Debt]) -> Completable {
        let debtDocuments = Single.zip(debts.map { $0.document() })
        return debtDocuments.flatMapCompletable { self.debtDataStore.delete($0) }
    }

    func listen(request: DebtRequest) -> Observable<[Debt]> {
        return debtDataStore.listen(request)
            .map { $0.extractData() }
    }
}

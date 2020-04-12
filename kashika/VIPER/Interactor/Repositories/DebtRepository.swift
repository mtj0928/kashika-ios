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

    // 多分いらない
    func listen(user: User) -> Observable<[Debt]> {
        return user.document()
            .asObservable()
            .flatMap { user in
                self.debtDataStore.listen(user: user).map { documents -> [Debt] in
                    documents.compactMap { $0.data }
                }.share()
        }
    }

    func listen(request: DebtRequest) -> Observable<[Debt]> {
        return debtDataStore.listen(request)
            .map { $0.extractData() }
    }
}

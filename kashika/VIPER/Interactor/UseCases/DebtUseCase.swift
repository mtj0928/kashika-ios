//
//  DebtUseCase.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift

class DebtUseCase {

    private let userUseCase = UserUseCase()
    private let debtRepository = DebtRepository()

    func create(money: Int, friends: [Friend], paymentDate: Date?, memo: String?, type: DebtType) -> Single<[Debt]> {
        userUseCase.fetchOrCreateUser()
            .flatMap { self.debtRepository.create(owner: $0, money: money, friends: friends, paymentDate: paymentDate, memo: memo, type: type) }
    }

    func listen(_ requestCreator: @escaping (User) -> DebtRequest) -> Observable<[Debt]> {
        return userUseCase.fetchOrCreateUser()
            .map { requestCreator($0) }
            .asObservable()
            .flatMap { self.debtRepository.listen(request: $0) }
    }
}

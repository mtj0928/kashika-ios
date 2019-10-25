//
//  DebtUseCase.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa
import Ballcap

class DebtUseCase {
    let debts = BehaviorRelay<[Debt]>(value: [])

    private let friendUseCase = FriendUseCase()
    private let friendRepository = FriendRepository()
    private let userRepository = UserRepository()
    private let debtRepository = DebtRepository()

    private let disposeBag = RxSwift.DisposeBag()

    init() {
        userRepository
            .fetchOrCreateUser()
            .subscribe(onSuccess: { [weak self] user in
                self?.debtRepository.listen(user: user)
            }).disposed(by: disposeBag)

        debtRepository.debtsObservable
            .subscribe(onNext: { [weak self] documents in
                let values: [Debt] = documents
                    .compactMap({ $0.data })
                self?.debts.accept(values)
            }).disposed(by: disposeBag)
    }

    func create(_ debts: [UnstoredDebt]) -> Single<[Document<Debt>]> {
        let user = userRepository.fetchOrCreateUser()
        let unstoredDebtSingles = debts.compactMap { [weak self] unstoredDebt in
            self?.friendUseCase.fetch(id: unstoredDebt.friend.id)
                .map({ UnstoredDebt(from: unstoredDebt, document: $0) })
        }

        let unstoredDebts = Single.zip(unstoredDebtSingles)

        return Single.zip(unstoredDebts, user)
            .flatMap({ [weak self] (debts: [UnstoredDebt], user: Document<User>) in
                guard let `self` = self else {
                    return Single.error(NSError())
                }
                return self.debtRepository.create(debts: debts, user: user)
            })
    }
}

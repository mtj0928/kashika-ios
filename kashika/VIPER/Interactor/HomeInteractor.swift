//
//  HomeInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

struct HomeInteractor: HomeInteractorProtocol {
    var user: BehaviorRelay<User?> {
        userDisposer.behaviorRelay
    }
    let scheduledDebts: BehaviorRelay<[Debt]> = BehaviorRelay(value: [])
    let friends: BehaviorRelay<[String? : Friend]> = BehaviorRelay(value: [:])
    let kashiFriend: BehaviorRelay<[Friend]> = BehaviorRelay(value: [])
    let kariFriend: BehaviorRelay<[Friend]> = BehaviorRelay(value: [])

    private let userDisposer: ListenerDisposer<User?, DocumentListener<User>>
    private let userUseCase = UserUseCase()
    private let friendUseCase = FriendUseCase()
    private let debtUseCase = DebtUseCase()
    private let disposeBag = DisposeBag()
    
    init() {
        userDisposer = ListenerDisposer(userUseCase.listen(), { $0?.data })
        userUseCase.fetchOrCreateUser()
            .subscribe(onSuccess: { [self] user in
                self.user.accept(user.data)
            }).disposed(by: disposeBag)

        debtUseCase.debts.map({ debt in
            debt.filter({ !$0.isPaid && $0.paymentDate != nil })
        }).map { debts -> [Debt] in
            return debts.sorted { (debt1, debt2) -> Bool in
                // swiftlint:disable:next force_unwrapping
                return debt1.paymentDate!.dateValue() < debt2.paymentDate!.dateValue()
            }
        }.subscribe(onNext: { [self] debts in
            self.scheduledDebts.accept(debts)
        }).disposed(by: disposeBag)

        // TODO: - ここ
//        friendUseCase.friends.subscribe(onNext: { [self] friends in
//            var dictionary: [String?: Friend] = [:]
//            friends.forEach({ dictionary[$0.id] = $0 })
//            self.friends.accept(dictionary)
//        }).disposed(by: disposeBag)
//
//        friendUseCase.friends.map({ (friends: [Friend]) -> [Friend] in
//            return friends.filter({ Int($0.totalDebt.rawValue) > 0 })
//        }).subscribe(onNext: { [self] friends in
//            self.kariFriend.accept(friends)
//        }).disposed(by: disposeBag)
//
//        friendUseCase.friends.map({ (friends: [Friend]) -> [Friend] in
//            return friends.filter({ Int($0.totalDebt.rawValue) < 0 })
//        }).subscribe(onNext: { [self] friends in
//            self.kashiFriend.accept(friends)
//        }).disposed(by: disposeBag)
    }
}

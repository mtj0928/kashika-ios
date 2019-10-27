//
//  HomeInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

class HomeInteractor: HomeInteractorProtocol {
    let user: BehaviorRelay<User?>
    let scheduledDebts: BehaviorRelay<[Debt]> = BehaviorRelay(value: [])
    let friends: BehaviorRelay<[String? : Friend]>
    let kashiFriend: BehaviorRelay<[Friend]>
    let kariFriend: BehaviorRelay<[Friend]>

    private let userUseCase = UserUseCase()
    private let friendUseCase = FriendUseCase()
    private let debtUseCase = DebtUseCase()
    private let disposeBag = DisposeBag()

    private let _observable: Observable<User?>

    init() {
        _observable = userUseCase.listen().map({ $0.data })
        // TODO: - Updateされないバグあり
        user = BehaviorRelay.create(observable: _observable,
                                    initialValue: nil,
                                    disposeBag: disposeBag)

        let observable = friendUseCase.listen({ FriendRequest(user: $0) })
            .map({ $0.extractData() })
            .map({ friends -> [String? : Friend] in
                var dictionary: [String?: Friend] = [:]
                friends.forEach({ dictionary[$0.id] = $0 })
                return dictionary
            })
        friends = BehaviorRelay.create(observable: observable,
                                       initialValue: [:],
                                       disposeBag: disposeBag)
        kariFriend = BehaviorRelay.create(observable: friendUseCase.listen({ FriendRequest(user: $0, debtType: .kari) }).map({ $0.extractData() }),
                                          initialValue: [],
                                          disposeBag: disposeBag)
        kashiFriend = BehaviorRelay.create(observable: friendUseCase.listen({ FriendRequest(user: $0, debtType: .kashi) }).map({ $0.extractData() }),
                                           initialValue: [],
                                           disposeBag: disposeBag)

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
    }
}

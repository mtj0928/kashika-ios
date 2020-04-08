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
import Firebase

class DebtUseCase {
    let debts = BehaviorRelay<[Debt]>(value: [])

    private let userUseCase = UserUseCase()
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

    func create(money: Int, friends: [Friend], paymentDate: Date?, memo: String?, type: DebtType) -> Single<[Document<Debt>]> {
        let money = type == .kari ? money : -money
        let userSingle = userUseCase.fetchOrCreateUser()
        let friendsSingle = Single.zip(friends.map({ FriendUseCase().fetch(id: $0.id) }))
        return Single.zip(userSingle, friendsSingle)
            .flatMap { (user, friends) in
                let debts = friends.map({ friend -> Document<Debt> in
                    let collectionReference = user.documentReference.collection(DebtDataStore.key)
                    let document = Document<Debt>(collectionReference: collectionReference)
                    document.data = Debt(money: money, friendId: friend.id, paymentDate: paymentDate?.ex.asTimestamp(), memo: memo, isPaid: false)
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

    func listen(_ requestCreator: (Document<User>) -> Void) -> Observable<[Document<Debt>]> {
        return Observable.just([])
    }
}

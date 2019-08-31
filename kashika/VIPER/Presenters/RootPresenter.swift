//
//  RootPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

struct RootPresenter: RootPresenterProtocol {
    let canShowFloatingPannel = BehaviorRelay<Bool>(value: false)
    var messages: Observable<MessageNotification> {
        return messagesSubject
    }
    private var messagesSubject = PublishSubject<MessageNotification>()

    private let interactor: RootInteractorProtocol
    private let router: RootRouterProtocol
    private let disposeBag = DisposeBag()

    init(interactor: RootInteractorProtocol, router: RootRouterProtocol) {
        self.interactor = interactor
        self.router = router

        interactor.fetchOrCreateCurrentUser()
            .subscribe()
            .disposed(by: disposeBag)
    }

    func showFloatingPannel() {
        router.showFloatingPannel(canShowFloatingPannel)
            .flatMap({ $0.debts })
            .flatMap({ (debts: [Debt]) -> Single<([Debt], Friend?)> in
                let friendId = debts.first?.friendId
                let friendSingle = self.interactor.fetchFriend(id: friendId)
                return Single.zip(Single.just(debts), friendSingle)
            }).subscribe(onNext: { (debts, friend) in
                guard let friend = friend,
                    let message = self.generateAddDebtMessage(from: debts, firstFriend: friend) else {
                        return
                }
                self.messagesSubject.onNext(message)
            }, onError: { error in
                self.messagesSubject.onError(error)
            }).disposed(by: disposeBag)
    }

    private func generateAddDebtMessage(from debts: [Debt], firstFriend friend: Friend) -> MessageNotification? {
        guard let debt = debts.first else {
            return nil
        }
        let debtType = DebtType.make(debt: debt)
        let isMultipleFriends = debts.count >= 2

        // swiftlint:disable:next force_unwrapping
        let message = (isMultipleFriends ? friend.name + "ら": friend.name) + "に" + (String.convertWithComma(from: abs(debt.money))!) + "円を\(debtType.rawValue)ました"
        let messageNotification = MessageNotification(title: "貸し借りの記録", body: message, url: friend.iconFile?.url, image: nil)
        return messageNotification
    }
}

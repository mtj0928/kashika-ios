//
//  WarikanSettingPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/30.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

final class WarikanSettingPresenter: WarikanSettingPresenterProtocol {

    let usersWhoHavePaid = BehaviorRelay<[WarikanUserWhoHasPaid]>(value: [])
    let usersWhoWillPay = BehaviorRelay<[WarikanUserWhoWillPay]>(value: [])
    let flows = BehaviorRelay<[WarikanDebtFlow]>(value: [])

    private let totalMoney: Int
    private let interactor: WarikanInteractorProtocol
    private let router: WarikanRouterProtocol
    private let disposeBag = DisposeBag()

    init(friends: [Friend], value: Int, type: WarikanInputMoaneyType, interactor: WarikanInteractorProtocol, router: WarikanRouterProtocol) {
        self.totalMoney = type == WarikanInputMoaneyType.sum ? value : value * (friends.count + 1)
        self.interactor = interactor
        self.router = router

        setupUsers(friends: friends, value: value, type: type)
        setupFlows()
    }

    private func setupUsers(friends: [Friend], value: Int, type: WarikanInputMoaneyType) {
        interactor.createInitialWarikanUsersWhoHavePaid(friends: friends, value: value, type: type)
            .subscribe(onSuccess: { [weak self] users in
                self?.usersWhoHavePaid.accept(users)
            })
            .disposed(by: disposeBag)

        interactor.createInitialWarikanUsersWhoWillPay(friends: friends, value: value, type: type)
            .subscribe(onSuccess: { [weak self] users in
                self?.usersWhoWillPay.accept(users)
            })
            .disposed(by: disposeBag)
    }

    private func setupFlows() {
        Observable.of(
            usersWhoHavePaid.map { $0 as [WarikanUser] },
            usersWhoWillPay.map { $0 as [WarikanUser] }
        )
            .merge()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.interactor
                    .compute(usersWhoHavePaid: self.usersWhoHavePaid.value, usersWhoWillPay: self.usersWhoWillPay.value)
                    .subscribe(onSuccess: { flow in
                        self.flows.accept(flow)
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }

    func tappedSaveButton() {
    }

    func dismiss() {
        router.dismiss()
    }

    func tapped(user: WarikanUserWhoHasPaid) {
        interactor.select(user, in: usersWhoHavePaid.value, totalMoney: totalMoney)
            .subscribe(onSuccess: { [weak self] users in
                self?.usersWhoHavePaid.accept(users)
            }).disposed(by: disposeBag)
    }

    func tapped(user: WarikanUserWhoWillPay) {
        interactor.select(user, in: usersWhoWillPay.value, totalMoney: totalMoney)
            .subscribe(onSuccess: { [weak self] users in
                self?.usersWhoWillPay.accept(users)
            }).disposed(by: disposeBag)
    }

    func tappedMoney(for user: WarikanUserWhoHasPaid) {
        tappedMoney(for: user, users: usersWhoHavePaid)
    }

    func tappedMoney(for user: WarikanUserWhoWillPay) {
        tappedMoney(for: user, users: usersWhoWillPay)
    }

    func tappedMoney<User: WarikanUser>(for user: User, users: BehaviorRelay<[User]>) {
        let input = EditMoneyInput(money: user.value)
        router.toEditMoneyView(input: input)
            .money
            .flatMap { [weak self] money -> Observable<[User]> in
                guard let self = self else {
                    return Observable.just([])
                }
                return self.interactor
                    .update(money, for: user, in: users.value, totalMoney: self.totalMoney)
                    .asObservable()
        }.subscribe(onNext: { newUsers in
            users.accept(newUsers)
        }).disposed(by: disposeBag)
    }

    func tappedDivideButton() {
        interactor.divideEqually(for: usersWhoWillPay.value, totalMoney: totalMoney)
            .subscribe(onSuccess: { [weak self] users in
                self?.usersWhoWillPay.accept(users)
            }).disposed(by: disposeBag)
    }
}

//
//  WarikanInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/06/02.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift

struct WarikanInteractor: WarikanInteractorProtocol {

    private let userUseCase = UserUseCase()
    private let flowsUseCase = WarikanDebtFlowUseCase()
    private let debtBalanceUseCase = DebtBalanceUseCase()

    func createInitialWarikanUsersWhoHavePaid(friends: [Friend], value: Int, type: WarikanInputMoaneyType) -> Single<[WarikanUserWhoHasPaid]> {
        userUseCase.fetchOrCreateUser()
            .flatMap { user in
                self.debtBalanceUseCase.createInitialWarikanUsersWhoHavePaid(user: user, friends: friends, value: value, type: type)
        }
    }

    func createInitialWarikanUsersWhoWillPay(friends: [Friend], value: Int, type: WarikanInputMoaneyType) -> Single<[WarikanUserWhoWillPay]> {
        userUseCase.fetchOrCreateUser()
            .flatMap { user in
                self.debtBalanceUseCase.createInitialWarikanUsersWhoWillPay(user: user, friends: friends, value: value, type: type)
        }
    }

    func select<User: WarikanUser>(_ user: User, in users: [User], totalMoney: Int) -> Single<[User]> {
        debtBalanceUseCase.select(user, in: users, totalMoney: totalMoney)
    }

    func update<User: WarikanUser>(_ money: Int, for user: User, in users: [User], totalMoney: Int) -> Single<[User]> {
        debtBalanceUseCase.update(money, for: user, in: users, totalMoney: totalMoney)
    }

    func divideEqually(for users: [WarikanUserWhoWillPay], totalMoney: Int) -> Single<[WarikanUserWhoWillPay]> {
        debtBalanceUseCase.divideEqually(for: users, totalMoney: totalMoney)
    }

    func compute(usersWhoHavePaid: [WarikanUserWhoHasPaid], usersWhoWillPay: [WarikanUserWhoWillPay]) -> Single<[WarikanDebtFlow]> {
        flowsUseCase.compute(usersWhoHavePaid: usersWhoHavePaid, usersWhoWillPay: usersWhoWillPay)
    }
}

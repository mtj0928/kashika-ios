//
//  DebtBalanceUseCase.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/06/07.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift

struct DebtBalanceUseCase {

    func createInitialWarikanUsersWhoHavePaid(user: User, friends: [Friend], value: Int, type: WarikanInputMoaneyType) -> Single<[WarikanUserWhoHasPaid]> {
        Single.create { observer in
            var users = [WarikanUserWhoHasPaid(money: 0, user: user)]
            users += friends.map { WarikanUserWhoHasPaid(money: 0, friend: $0) }
            observer(.success(users))
            return Disposables.create()
        }
    }

    func createInitialWarikanUsersWhoWillPay(user: User, friends: [Friend], value: Int, type: WarikanInputMoaneyType) -> Single<[WarikanUserWhoWillPay]> {
        Single.create { observer in
            let money = type == .per ? value : 0
            var users = [WarikanUserWhoWillPay(money: money, user: user)]
            users += friends.map { WarikanUserWhoWillPay(money: money, friend: $0) }
            users.forEach { $0.isSelected = money != 0 }
            observer(.success(users))
            return Disposables.create()
        }
    }

    func select<User: WarikanUser>(_ user: User, in users: [User], totalMoney: Int) -> Single<[User]> {
        Single.create { observer -> Disposable in
            if user.isEdited {
                user.reset()
            } else {
                user.isSelected = !user.isSelected
                user.value = 0
            }

            let newUsers = self.updateUsers(users: users, totalMoney: totalMoney)
            observer(.success(newUsers))
            return Disposables.create()
        }
    }

    func update<User: WarikanUser>(_ money: Int, for user: User, in users: [User], totalMoney: Int) -> Single<[User]> {
        Single.create { observer -> Disposable in
            let money = min(money, totalMoney)

            user.value = money
            user.isSelected = money != 0
            user.isEdited = true
            let newUsers = self.updateUsers(users: users, totalMoney: totalMoney)
            observer(.success(newUsers))
            return Disposables.create()
        }
    }

    func divideEqually(for users: [WarikanUserWhoWillPay], totalMoney: Int) -> Single<[WarikanUserWhoWillPay]> {
        Single.create { observer -> Disposable in
            users.forEach {
                $0.reset()
                $0.isSelected = true
            }
            let newUsers = self.updateUsers(users: users, totalMoney: totalMoney)
            observer(.success(newUsers))
            return Disposables.create()
        }
    }

    private func updateUsers<User: WarikanUser>(users: [User], totalMoney: Int) -> [User] {
        let editedMoney = users.filter { $0.isEdited }
            .map { $0.value }
            .reduce(0) { $0 + $1 }

        if totalMoney <= editedMoney {
            return users
        }

        let diff = totalMoney - editedMoney
        let seletedUsers = users.filter { $0.isSelected && !$0.isEdited }

        if seletedUsers.isEmpty {
            return users
        }

        let valuePerUser = diff / seletedUsers.count
        seletedUsers.forEach { $0.value = valuePerUser }

        let remainder = diff % seletedUsers.count
        (0..<remainder).forEach { seletedUsers[$0].value += 1 }

        return users
    }
}

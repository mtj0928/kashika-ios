//
//  WarikanDebtFlowUseCase.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/06/07.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift

struct WarikanDebtFlowUseCase {

    private struct LocalUser {
        let value: Int
        let warikanUser: WarikanUser

        var user: User? {
            warikanUser.user
        }
        var friend: Friend? {
            warikanUser.friend
        }

        init(user: WarikanUser, value: Int) {
            self.warikanUser = user
            self.value = value
        }
    }

    func compute(usersWhoHavePaid: [WarikanUserWhoHasPaid], usersWhoWillPay: [WarikanUserWhoWillPay]) -> Single<[WarikanDebtFlow]> {
        setup(usersWhoHavePaid: usersWhoHavePaid, usersWhoWillPay: usersWhoWillPay)
            .map { self.computeFlow(users: $0, flows: []) }
    }

    private func setup(usersWhoHavePaid: [WarikanUserWhoHasPaid], usersWhoWillPay: [WarikanUserWhoWillPay]) -> Single<[LocalUser]> {
        Single.create { observer  in
            var me: LocalUser?
            var users: [String: LocalUser] = [:]

            usersWhoHavePaid.forEach { warikanUser in
                if warikanUser.user != nil {
                    me = LocalUser(user: warikanUser, value: warikanUser.value)
                } else if let friend = warikanUser.friend {
                    users[friend.id] = LocalUser(user: warikanUser, value: warikanUser.value)
                }
            }

            usersWhoWillPay.forEach { warikanUser in
                if warikanUser.user != nil {
                    if let localUser = me {
                        me = LocalUser(user: warikanUser, value: localUser.value - warikanUser.value)
                    } else {
                        me = LocalUser(user: warikanUser, value: -warikanUser.value)
                    }
                } else if let friend = warikanUser.friend {
                    if let localUser = users[friend.id] {
                        users[friend.id] = LocalUser(user: warikanUser, value: localUser.value - warikanUser.value)
                    } else {
                        users[friend.id] = LocalUser(user: warikanUser, value: -warikanUser.value)
                    }
                }
            }

            var localUsers = Array(users.values)
            if let me = me {
                localUsers.append(me)
            }
            observer(.success(localUsers))

            return Disposables.create()
        }
    }

    private func computeFlow(users: [LocalUser], flows: [WarikanDebtFlow]) -> [WarikanDebtFlow] {
        if !users.contains(where: { $0.value != 0 }) {
            return flows
        }

        guard let maxPlusUser = users.filter({ $0.value > 0 }).sorted(by: { $0.value >= $1.value }).first,
            let minMinusUser = users.filter({ $0.value < 0 }).sorted(by: { $0.value <= $1.value }).first else {
                return []
        }

        let value = min(abs(maxPlusUser.value), abs(minMinusUser.value))

        var flows = flows
        let newFlow = WarikanDebtFlow(from: minMinusUser.warikanUser, to: maxPlusUser.warikanUser, value: value)

        let newLocalUssrs = users.map { user -> LocalUser in
            if user.friend == maxPlusUser.friend && user.user == maxPlusUser.user {
                return LocalUser(user: user.warikanUser, value: user.value - value)
            }
            if user.friend == minMinusUser.friend && user.user == minMinusUser.user {
                return LocalUser(user: user.warikanUser, value: user.value + value)
            }
            return user
        }

        flows.append(newFlow)
        return computeFlow(users: newLocalUssrs, flows: flows)
    }
}

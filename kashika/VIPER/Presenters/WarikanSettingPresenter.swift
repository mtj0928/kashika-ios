//
//  WarikanSettingPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/30.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class WarikanSettingPresenter: WarikanSettingPresenterProtocol {

    let usersWhoHavePaid = BehaviorRelay<[WarikanUser]>(value: [])
    let usersWhoWillPay = BehaviorRelay<[WarikanUser]>(value: [])

    private let userUseCase = UserUseCase()
    private let disposeBag = DisposeBag()

    init(friends: [Friend], value: Int, type: WarikanInputMoaneyType) {
        userUseCase.fetchOrCreateUser()
            .subscribe(onSuccess: { [weak self] user in
                var havePaidUser = [WarikanUser(user: user, friend: nil, value: value)]
                havePaidUser += friends.map { WarikanUser(user: nil, friend: $0, value: 0) }

                var willPayUser = [WarikanUser(user: user, friend: nil, value: value / (friends.count + 1))]
                willPayUser += friends.map { WarikanUser(user: nil, friend: $0, value: value / (friends.count + 1)) }

                self?.usersWhoHavePaid.accept(havePaidUser)
                self?.usersWhoWillPay.accept(willPayUser)
            }).disposed(by: disposeBag)
    }

    func tappedSaveButton() {
    }
}

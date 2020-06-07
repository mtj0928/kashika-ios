//
//  WarikanSettingContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/30.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import FirebaseStorage
import RxSwift
import RxCocoa

protocol WarikanSettingPresenterProtocol {
    var usersWhoHavePaid: BehaviorRelay<[WarikanUserWhoHasPaid]> { get }
    var usersWhoWillPay: BehaviorRelay<[WarikanUserWhoWillPay]> { get }
    var flows: BehaviorRelay<[WarikanDebtFlow]> { get }

    func tappedSaveButton()
    func dismiss()
    func tapped(user: WarikanUserWhoHasPaid)
    func tapped(user: WarikanUserWhoWillPay)
    func tappedMoney(for: WarikanUserWhoHasPaid)
    func tappedMoney(for: WarikanUserWhoWillPay)
    func tappedDivideButton()
}

protocol WarikanInteractorProtocol {
    func createInitialWarikanUsersWhoHavePaid(friends: [Friend], value: Int, type: WarikanInputMoaneyType) -> Single<[WarikanUserWhoHasPaid]>
    func createInitialWarikanUsersWhoWillPay(friends: [Friend], value: Int, type: WarikanInputMoaneyType) -> Single<[WarikanUserWhoWillPay]>
    func select<User: WarikanUser>(_ user: User, in users: [User], totalMoney: Int) -> Single<[User]>
    func update<User: WarikanUser>(_ money: Int, for user: User, in users: [User], totalMoney: Int) -> Single<[User]>
    func divideEqually(for users: [WarikanUserWhoWillPay], totalMoney: Int) -> Single<[WarikanUserWhoWillPay]>
}

protocol WarikanRouterProtocol {
    func dismiss()
    func toEditMoneyView(input: EditMoneyInputProtocol) -> EditMoneyOutputProtocol 
}

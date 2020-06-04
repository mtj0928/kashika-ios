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

class WarikanUser {
    var value: Int
    let name: String
    let iconFile: StorageReference?

    let user: User?
    let friend: Friend?

    var isEdited = false
    var isSelected = false

    init(money: Int, user: User) {
        self.value = money
        self.name = "私"
        self.iconFile = nil
        self.user = user
        self.friend = nil
    }

    init(money: Int, friend: Friend) {
        self.value = money
        self.name = friend.name
        self.iconFile = friend.iconFile?.storageReference
        self.user = nil
        self.friend = friend
    }

    func reset() {
        isSelected = false
        isEdited = false
        value = 0
    }
}

class WarikanUserWhoHasPaid: WarikanUser {
}

class WarikanUserWhoWillPay: WarikanUser {
}

protocol WarikanSettingPresenterProtocol {
    var usersWhoHavePaid: BehaviorRelay<[WarikanUserWhoHasPaid]> { get }
    var usersWhoWillPay: BehaviorRelay<[WarikanUserWhoWillPay]> { get }

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

//
//  WarikanUser.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/06/05.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import FirebaseStorage

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

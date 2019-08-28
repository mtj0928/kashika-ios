//
//  AddDebtInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/24.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxCocoa

class AddDebtInteractor: AddDebtInteractorProtocol {
    var friends: BehaviorRelay<[Friend]> {
        return friendsUseCase.friends
    }

    let friendsUseCase = FriendUseCase()
}

//
//  FriendListInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

class FriendListInteractor: FriendListInteractorProtocol {
    var friends: BehaviorRelay<[Friend]> {
        return friendListUseCase.friends
    }

    private let disposeBag = DisposeBag()
    private let friendListUseCase = FriendListUseCase()
}

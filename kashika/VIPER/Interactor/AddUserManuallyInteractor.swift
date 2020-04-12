//
//  AddUserManuallyInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift

struct AddUserManuallyInteractor: AddUserManuallyInteractorProtocol {

    func addUser(name: String, icon: UIImage?) -> MonitorObservable<Friend?> {
        return FriendUseCase(user: UserUseCase().fetchOrCreateUser())
            .create(name: name, icon: icon)
            .map { $0.map { friend in friend } }
    }
}

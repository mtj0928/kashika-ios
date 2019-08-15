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

    func addUser(name: String, icon: UIImage?) -> Single<Friend> {
        return UserUseCase().fetchOrCreateUser()
            .flatMap({ FriendDataStore().create(user: $0, name: name, icon: icon) })
    }
}

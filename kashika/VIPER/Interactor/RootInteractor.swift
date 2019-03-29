//
//  RootInteractor.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift

struct RootInteractor: RootInteractorProtocol {

    func fetchOrCreateCurrentUser() -> Single<User> {
        return UserUseCase().fetchOrCreateUser()
    }
}

//
//  RootConstracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift

protocol RootInteractorProtocol {

    func fetchOrCreateCurrentUser() -> Single<User>
}

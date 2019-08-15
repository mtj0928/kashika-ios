//
//  EditUsernameOutput.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift

struct EditUsernameOutput: EditUsernameOutputProtocol {
    var username: Observable<String?> {
        return usernameSubject
    }
    let usernameSubject = PublishSubject<String?>()
}

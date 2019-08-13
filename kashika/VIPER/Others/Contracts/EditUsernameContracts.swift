//
//  EditUsernameContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol EditUsernamePresenterProtocol: ModalTextFieldPresenterProtocol {
    var image: Observable<UIImage?> { get }
}

protocol EditUsernameRouterProtocol {
    func dismiss()
}

protocol EditUsernameOutputProtocol {
    var username: BehaviorRelay<String?> { get }
}

struct EditUsernameOutput: EditUsernameOutputProtocol {
    let username = BehaviorRelay<String?>(value: nil)
}

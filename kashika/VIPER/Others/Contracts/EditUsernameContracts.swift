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
    var output: EditUsernameOutputProtocol { get }
}

protocol EditUsernameRouterProtocol {
    func dismiss()
}

protocol EditUsernameInputProtocol {
    var username: String? { get }
}

protocol EditUsernameOutputProtocol {
    var username: Observable<String?> { get }
}

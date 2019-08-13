//
//  ModalTextFieldContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/13.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ModalTextFieldPresenterProtocol {
    var text: Observable<String?> { get }
    var title: Observable<String?> { get }
    var unit: Observable<String?> { get }
    var keyboardType: Observable<UIKeyboardType> { get }

    func inputed(text: String?)
    func tappedOkButton()
    func tappedCancelButton()
}

protocol ModalTextFieldOutputProtocol {
    var text: BehaviorRelay<String?> { get }
}

struct ModalTextFieldOutput: ModalTextFieldOutputProtocol {
    let text = BehaviorRelay<String?>(value: nil)
}

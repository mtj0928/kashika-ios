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
    var summaryIsHidden: Driver<Bool> { get }
    var summaryText: Driver<String?> { get }
    var keyboardType: Observable<ModalTextFieldKeyboardType> { get }

    func inputed(text: String?)
    func tappedOkButton()
    func tappedCancelButton()
}

//
//  EditUsernamePresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditUsernamePresenter: EditUsernamePresenterProtocol {
    var image: Observable<UIImage?> {
        return imageSubject
    }
    var text: Observable<String?> = BehaviorSubject(value: "")
    let title: Observable<String?> = BehaviorSubject(value: "名前を入力")
    let unit: Observable<String?> = BehaviorSubject(value: "")
    let keyboardType: Observable<UIKeyboardType> = BehaviorSubject(value: .default)

    private let imageSubject = BehaviorSubject<UIImage?>(value: nil)
    private let router: EditUsernameRouter

    private let output: EditUsernameOutputProtocol
    private var inputtedText: String?

    init(router: EditUsernameRouter, output: EditUsernameOutputProtocol) {
        self.router = router
        self.output = output
    }

    func inputed(text: String?) {
        self.inputtedText = text
    }

    func tappedOkButton() {
        output.username.accept(inputtedText)
        router.dismiss()
    }

    func tappedCancelButton() {
        router.dismiss()
    }
}

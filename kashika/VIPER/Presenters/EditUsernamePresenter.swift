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
    let text: Observable<String?>
    let title: Observable<String?> = BehaviorSubject(value: "名前を入力")
    let unit: Observable<String?> = BehaviorSubject(value: "")
    let summaryIsHidden: Driver<Bool> = BehaviorSubject(value: true).asDriver(onErrorJustReturn: true)
    let summaryText: Driver<String?> = Driver.just("")
    let keyboardType: Observable<ModalTextFieldKeyboardType> = BehaviorSubject(value: .default)
    var output: EditUsernameOutputProtocol {
        return rawOutput
    }

    private let imageSubject = BehaviorSubject<UIImage?>(value: nil)
    private let rawOutput = EditUsernameOutput()
    private let router: EditUsernameRouter
    private var inputtedText: String?

    init(router: EditUsernameRouter, input: EditUsernameInputProtocol) {
        self.router = router
        self.text = BehaviorSubject(value: input.username)
    }

    func inputed(text: String?) {
        self.inputtedText = text
    }

    func tappedOkButton() {
        rawOutput.usernameSubject.onNext(inputtedText)
        router.dismiss()
    }

    func tappedCancelButton() {
        router.dismiss()
    }
}

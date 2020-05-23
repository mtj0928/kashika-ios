//
//  EditMoneyPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/16.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct EditMoneyOutput: EditMoneyOutputProtocol {
    var money: Observable<Int> {
        return moneySubject
    }
    let moneySubject = PublishSubject<Int>()
}

final class EditMoneyPresenter: EditMoneyPresenterProtocol {
    var text: Observable<String?> {
        return textSubject
    }
    let title: Observable<String?> = BehaviorSubject(value: "金額を入力")
    let summaryIsHidden: Driver<Bool> = BehaviorSubject(value: false).asDriver(onErrorJustReturn: false)
    var summaryText: Driver<String?> {
        return summaryTextSubject.asDriver(onErrorJustReturn: "")
    }
    let unit: Observable<String?> = BehaviorSubject(value: "円")
    private(set) lazy var keyboardType: Observable<ModalTextFieldKeyboardType> = BehaviorSubject(value: .calculator(enableToInsertButtonDriver: enableToInsertSymbolDriver))
    var output: EditMoneyOutputProtocol {
        return _output
    }

    private var money = 0
    private let calculator = Calculator()
    private let textSubject: BehaviorSubject<String?>
    private let summaryTextSubject: BehaviorSubject<String?>
    private let enableToInsertSymbolSubject = BehaviorSubject(value: false)
    private lazy var enableToInsertSymbolDriver: Driver<Bool> = enableToInsertSymbolSubject.asDriver(onErrorJustReturn: false)
    private let _output = EditMoneyOutput()
    private let router: EditMoneyRouterProtocol

    init(router: EditMoneyRouterProtocol, input: EditMoneyInputProtocol) {
        money = input.money
        self.textSubject = BehaviorSubject(value: String(money))
        self.summaryTextSubject = BehaviorSubject(value: String.convertWithComma(from: money))
        self.router = router
    }

    func inputed(text: String?) {
        guard let text = text else {
            return
        }

        if text.isEmpty {
            self.money = 0
            self.textSubject.onNext("0")
            self.summaryTextSubject.onNext("0")
            return
        }

        var newText = text
        do {
            let tokens = calculator.performLexicalAnalysis(text)
            newText = tokens.map { token -> String in
                if Calculator.operations.contains(token) {
                    return token
                }
                // swiftlint:disable force_try
                var newToken = token.replace(try! Regex("^0*$"), with: "0")
                // swiftlint:enable force_try
                if newToken.count >= 2 && newToken.starts(with: "0") && !newToken.starts(with: "0.") {
                    newToken.removeFirst()
                }
                return newToken
            }.reduce("", { $0 + $1 })
            let money = try calculator.calculate(tokens)
            enableToInsertSymbolSubject.onNext(true)
            self.money = money.intValue
            self.textSubject.onNext(newText)
            self.summaryTextSubject.onNext(String.convertWithComma(from: money.intValue))

        } catch let error {
            guard let error = error as? CalculatorError else {
                return
            }
            switch error {
            case .insufficientError:
                let money = NSDecimalNumber(value: self.money)
                self.money = money.intValue
                enableToInsertSymbolSubject.onNext(false)
                self.textSubject.onNext(newText)
                self.summaryTextSubject.onNext(String.convertWithComma(from: money.intValue))
            case .consecutiveOperators, .zeroDevisionError, .invalidError:
                self.money = 0
                enableToInsertSymbolSubject.onNext(false)
                textSubject.onNext(text)
                summaryTextSubject.onNext("エラー")
            }
        }
    }

    func tappedOkButton() {
        _output.moneySubject.onNext(money)
        router.dismiss()
    }

    func tappedCancelButton() {
        router.dismiss()
    }
}

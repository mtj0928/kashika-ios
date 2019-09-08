//
//  AddDebtPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/05.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class AddDebtPresenter: AddDebtPresenterProtocol {

    let isDecelerating: BehaviorRelay<Bool>
    let selectedIndexes = BehaviorRelay<Set<Int>>(value: [])
    let isSelected = BehaviorRelay<Bool>(value: false)
    var canBeAddDebt: Observable<Bool> {
        let moneyIsInputed = money.map({ $0 != 0 })
        return Observable.combineLatest(isSelected.asObservable(), moneyIsInputed)
            .map({ $0.0 && $0.1 })
            .share()
    }
    var friends: BehaviorRelay<[Friend]> {
        return interactor.friends
    }
    let money = BehaviorRelay<Int>(value: 0)
    var shouldShowPlaceHolder: Observable<Bool> {
        return money.asObservable().map({ $0 == 0 }).share()
    }
    var output: Observable<AddDebtOutputProtocol> {
        return outputSubject
    }
    private let outputSubject = PublishSubject<AddDebtOutputProtocol>()
    let selectedDate: BehaviorRelay<Date?> = BehaviorRelay(value: nil)
    let shouldOpenCalendar: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let memo: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
    private let interactor: AddDebtInteractorProtocol
    private let router: AddDebtRouterProtocol
    private let disposeBag = DisposeBag()

    init(_ isDecelerating: BehaviorRelay<Bool>, interactor: AddDebtInteractorProtocol, router: AddDebtRouterProtocol) {
        self.isDecelerating = isDecelerating
        self.interactor = interactor
        self.router = router

        selectedIndexes.subscribe(onNext: { [weak self] indexes in
            self?.isSelected.accept(!indexes.isEmpty)
        }).disposed(by: disposeBag)
    }

    func createDebt(debtType: DebtType) {
        let debts = selectedIndexes.value
            .compactMap({ friends.value[$0] })
            .map({ [weak self] friend in
                self!.createUnstoredDebt(friend: friend, debtType: debtType)
            })

        let debtsSingle = interactor.save(debts: debts)
        let output = AddDebtOutput(debts: debtsSingle)
        outputSubject.onNext(output)

        router.dismiss()
    }

    private func createUnstoredDebt(friend: Friend, debtType: DebtType) -> UnstoredDebt {
        return UnstoredDebt(money: money.value, friend: friend, paymentDate: selectedDate.value, memo: memo.value, type: debtType)
    }

    func tappedCloseButton() {
        router.dismiss()
    }

    func tappedMoneyButton() {
        let input = EditMoneyInput(money: money.value)
        let output = router.toEditMoneyView(input: input)
        
        output.money.subscribe(onNext: { [weak self] money in
            self?.money.accept(money)
        }).disposed(by: disposeBag)
    }

    func getStatus(at index: Int) -> CellStatus {
        if !isSelected.value {
            return CellStatus.none
        }
        if selectedIndexes.value.contains(index) {
            return CellStatus.selected
        }
        return CellStatus.notSelected
    }

    func selectFriend(at index: Int) {
        var selected = selectedIndexes.value
        if selected.contains(index) {
            selected.remove(index)
        } else {
            selected.insert(index)
        }
        selectedIndexes.accept(selected)
    }

    func dismissedFloatingPanel() {
        router.dismiss()
    }
}

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
    var friends: BehaviorRelay<[Friend]> {
        return interactor.friends
    }
    let money = BehaviorRelay<Int>(value: 0)
    var shouldShowPlaceHolder: Observable<Bool> {
        return money.asObservable().map({ $0 == 0 })
    }

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

    func createDebt() {
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

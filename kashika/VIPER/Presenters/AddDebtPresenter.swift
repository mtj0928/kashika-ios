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

    let selectedIndexes = BehaviorRelay<Set<Int>>(value: [])
    let isSelected = BehaviorRelay<Bool>(value: false)
    let friends = BehaviorRelay<[User]>(value: [])
    let money = BehaviorRelay<Int>(value: 1080)

    private let router: AddDebtRouterProtocol
    private let disposeBag = DisposeBag()

    init(router: AddDebtRouterProtocol) {
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
        router.toEditMoneyView(money: money)
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
}

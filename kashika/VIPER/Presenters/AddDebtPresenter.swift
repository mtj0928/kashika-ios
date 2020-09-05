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

enum WarikanInputMoaneyType {
    case sum, per
}

final class AddDebtPresenter: AddDebtPresenterProtocol {

    let isDecelerating: BehaviorRelay<Bool>
    let selectedIndexes = BehaviorRelay<Set<Int>>(value: [])
    let isSelected = BehaviorRelay<Bool>(value: false)
    private(set) lazy var canBeAddDebt: Observable<Bool> = {
        let moneyIsInputed = money.map({ $0 != 0 })
        return Observable.combineLatest(isSelected.asObservable(), moneyIsInputed)
            .map({ $0.0 && $0.1 })
            .share()
    }()
    var friends: BehaviorRelay<[Friend]> {
        return interactor.friends
    }

    private(set) lazy var isSumSelected = self.warikanInputMoneyType.map { $0 == .sum }.asDriver(onErrorJustReturn: false)
    private(set) lazy var isPerSelected = self.warikanInputMoneyType.map { $0 == .per }.asDriver(onErrorJustReturn: false)
    private let warikanInputMoneyType = BehaviorRelay<WarikanInputMoaneyType>(value: .sum)

    let money = BehaviorRelay<Int>(value: 0)
    var shouldShowPlaceHolder: Observable<Bool> {
        return money.asObservable().map({ $0 == 0 }).share()
    }
    private(set) lazy var isWarikan = warikanSwitchState.map { $0.isActive }
        .asDriver(onErrorJustReturn: false)

    private(set) lazy var isEnabledWarikanSwitch: Driver<Bool> = warikanSwitchState.map { $0.buttonEnable }
        .asDriver(onErrorJustReturn: false)

    private let showWarikanButtonSubject = BehaviorSubject(value: false)

    private let warikanSwitchState = BehaviorRelay<State>(value: .none)

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

            guard let self = self else {
                return
            }
            let state = self.warikanSwitchState.value
            let nextState = state.next(selectedFriendsCount: indexes.count, isButtonAtive: state.isActive)
            self.warikanSwitchState.accept(nextState)
        }).disposed(by: disposeBag)
    }

    func tappedWarikanSwitch(isActive: Bool) {
        let state = warikanSwitchState.value
        let nextState = state.next(selectedFriendsCount: selectedIndexes.value.count, isButtonAtive: isActive)
        warikanSwitchState.accept(nextState)
    }

    func tappedCloseButton() {
        router.dismiss()
    }

    func tappedSumButton() {
        warikanInputMoneyType.accept(.sum)
    }

    func tappedPerButton() {
        warikanInputMoneyType.accept(.per)
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

    func tappedWarikanSwitchButton(isActive: Bool) {
        showWarikanButtonSubject.onNext(isActive)
    }

    func tappedKashitaOrWarikanButton() {
        if warikanSwitchState.value.isActive {
            router.presentWarikan(value: money.value, friends: selectedIndexes.value.compactMap { [weak self] index in
                return self?.friends.value[index]
            }, type: warikanInputMoneyType.value)
        } else {
            createDebt(debtType: .kashi)
        }
    }

    func tappedKaritaButton() {
        createDebt(debtType: .kari)
    }

    private func createDebt(debtType: DebtType) {
        let friends = selectedIndexes.value
            .compactMap { self.friends.value[$0] }
        let debtsSingle = interactor.save(money: money.value, friends: friends,
                                          paymentDate: selectedDate.value, memo: memo.value, type: debtType)
        let output = AddDebtOutput(debts: debtsSingle)
        outputSubject.onNext(output)

        router.dismiss()
    }
}

extension AddDebtPresenter {

    enum State {
        case none, selectedActive, switchActive, selectedActiveFromSwitch

        var isActive: Bool {
            return self != .none
        }

        var buttonEnable: Bool {
            return self != .selectedActive && self != .selectedActiveFromSwitch
        }

        func next(selectedFriendsCount: Int, isButtonAtive: Bool) -> State {
            switch self {
            case .none:
                if selectedFriendsCount >= 2 {
                    return .selectedActive
                } else if isButtonAtive {
                    return .switchActive
                }
                return .none
            case .selectedActive:
                if selectedFriendsCount < 2 {
                    return .none
                }
                return .selectedActive
            case .switchActive:
                if selectedFriendsCount >= 2 {
                    return .selectedActiveFromSwitch
                } else if !isButtonAtive {
                    return .none
                }
                return .switchActive
            case .selectedActiveFromSwitch:
                if selectedFriendsCount < 2 {
                    return .switchActive
                }
                return .selectedActiveFromSwitch
            }
        }
    }
}

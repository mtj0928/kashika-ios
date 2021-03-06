//
//  HomePresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

class HomePresenter: HomePresenterProtocol {
    let userTotalDebtMoney: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    let sections: BehaviorRelay<[HomeSection]> = BehaviorRelay(value: [])

    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol
    private let disposeBag = DisposeBag()

    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
        subscribeInteractor()
    }

    private func subscribeInteractor() {
        interactor.privateUserInformation.subscribe(onNext: { [weak self] privateInfo in
            self?.userTotalDebtMoney.accept(Int(privateInfo?.totalDebt.rawValue ?? 0))
        }).disposed(by: disposeBag)

        Observable.combineLatest(interactor.scheduledDebts.asObservable(),
                                 interactor.kariFriend.asObservable(),
                                 interactor.kashiFriend.asObservable()
        ).subscribe(onNext: { [weak self] (scheduledDebts, kariFriends, kashiFriends) in
            var sections: [HomeSection] = [.summery]
            if !scheduledDebts.isEmpty {
                sections.append(.schedule)
            }
            if !kariFriends.isEmpty {
                sections.append(.kari)
            }
            if !kashiFriends.isEmpty {
                sections.append(.kashi)
            }
            self?.sections.accept(sections)
        }).disposed(by: disposeBag)
    }

    func resolveFriendGridPresenter(for section: HomeSection) -> FriendsGridPresenterProtocol? {
        switch section {
        case .summery:
            return nil
        case .schedule:
            return nil
        case .kari:
            return FriendsGridPresenter(interactor.kariFriend, router: router)
        case .kashi:
            return FriendsGridPresenter(interactor.kashiFriend, router: router)
        }
    }

    func resolveScheduledPresenter() -> ScheduledPresenterProtocol {
        // TODO: - ここで組み立てるべきではない
        let interactor = ScheduledInteractor()
        let presenter = ScheduledPresenter(interactor: interactor)
        return presenter
    }
}

//
//  FriendListPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/25.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

class FriendListPresenter: FriendListPresenterProtocol {

    typealias Router = FriendListRouterProtocol & SNSFooterRouterProtocol

    var friends: BehaviorRelay<[Friend]> {
        return interactor.friends
    }

    private let isSendingDataSubject = PublishSubject<Bool>()
    private let progressSubject = PublishSubject<Progress?>()

    private let interactor: FriendListInteractorProtocol
    private let router: Router
    private let disposeBag = DisposeBag()

    init(interactor: FriendListInteractorProtocol, router: Router) {
        self.interactor = interactor
        self.router = router
    }

    func tapped(friend: Friend) {
    }
}

// MARK: - SNSFooterPresenterProtocol

extension FriendListPresenter: SNSFooterPresenterProtocol {
    var isSendingData: Observable<Bool> {
        return isSendingDataSubject
    }

    var progress: Observable<Progress?> {
        return progressSubject
    }

    func tappedAddUserButton(with type: UserAdditionType) {
        router.showUserAddView(with: type)?
            .flatMap({ $0.monitor })
            .subscribe(onNext: { [weak self] monitor in
                self?.update(monitor: monitor)
            }).disposed(by: disposeBag)
    }

    private func update(monitor: Monitor<Friend?>) {
        progressSubject.onNext(monitor.progress)
        isSendingDataSubject.onNext(monitor.value == nil)
    }
}

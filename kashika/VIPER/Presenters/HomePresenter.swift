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
    let sections: BehaviorRelay<[HomeSection]> = BehaviorRelay(value: [])

    private let interactor: HomeInteractorProtocol
    private let disposeBag = DisposeBag()

    init(interactor: HomeInteractorProtocol) {
        self.interactor = interactor
        subscribeInteractor()
    }

    private func subscribeInteractor() {
        Observable.combineLatest(interactor.scheduledFriend.asObservable(),
                                 interactor.kariFriend.asObservable(),
                                 interactor.kashiFriend.asObservable()
        ).subscribe(onNext: { [weak self] (scheduledFriends, kariFriends, kashiFriends) in
            var sections: [HomeSection] = [.summery]
            if !scheduledFriends.isEmpty {
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
}

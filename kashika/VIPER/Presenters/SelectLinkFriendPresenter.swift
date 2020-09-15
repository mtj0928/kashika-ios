//
//  SelectLinkFriendPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/09/06.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa
import SVProgressHUD

class SelectLinkFriendPresenter: SimpleFriendListPresenterProtocol {
    var friends: BehaviorRelay<[Friend]> {
        interactor.friends
    }
    let title: Driver<String?> = BehaviorSubject(value: "リンクする友達を選択")
        .asDriver(onErrorDriveWith: .empty())

    private let interactor: SimpleFriendListInteractorProtocol
    private let router: SimpleFriendListRouterProtocol
    private let disposeBag = DisposeBag()

    init(interactor: SimpleFriendListInteractorProtocol, router: SimpleFriendListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func select(_ friend: Friend) {
        SVProgressHUD.show(withStatus: "通信中")
        interactor.select(friend)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onCompleted: { [weak self] in
                SVProgressHUD.dismiss()
                self?.router.select(friend)
            }).disposed(by: disposeBag)
    }

    func close() {
        router.close()
    }
}

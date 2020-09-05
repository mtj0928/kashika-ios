//
//  ConfirmationInvitePresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/26.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD

class ConfirmationInvitePresenter: ConfirmationInvitePresenterProtocol {
    let friend: FetchFriendWithToken.FetchedFriend
    private let interactor: ConfirmationInviteInteractorProtocol
    private let router: ConfirmationInviteRouterProtocol
    private let disposeBag = DisposeBag()

    init(_ friend: FetchFriendWithToken.FetchedFriend, interactor: ConfirmationInviteInteractorProtocol, router: ConfirmationInviteRouterProtocol) {
        self.friend = friend
        self.interactor = interactor
        self.router = router
    }

    func tappedAccept() {
        reaction(interactor.accept())
    }

    func tappedDeny() {
        reaction(interactor.deny())
    }

    private func reaction(_ actionCompleatable: Completable) {
        SVProgressHUD.show()
        actionCompleatable.subscribe(onCompleted: { [weak self] in
            SVProgressHUD.dismiss()
            self?.router.dismiss()
        }) { [weak self] error in
            print(error.localizedDescription)
            SVProgressHUD.dismiss()
            self?.router.dismiss()
        }.disposed(by: disposeBag)
    }
}

//
//  AddUserManuallyPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift

class AddUserManuallyPresenter: AddUserManuallyPresenterProtocol {
    private(set) var icon: Observable<UIImage?> = BehaviorSubject(value: nil)
    private(set) var name: Observable<String?> = BehaviorSubject(value: nil)

    private(set) lazy var isEnableToAdd: Observable<Bool>? = { [weak self] in
        guard let `self` = self else {
            return nil
        }

        return Observable.zip(self.icon, self.name).map {
            $0 != nil && $1 != nil
        }
    }()

    private let router: AddUserManuallyRouterProtocol

    init(router: AddUserManuallyRouterProtocol) {
        self.router = router
    }

    func showAlbum() {
    }

    func showModalTextField() {
        router.showModalTextField()
    }

    func add() {
    }

    func tappedCloseButton() {
        router.dismiss()
    }
}

//
//  AddUserManuallyPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddUserManuallyPresenter: AddUserManuallyPresenterProtocol {
    private(set) var icon: Observable<UIImage?> = BehaviorSubject(value: nil)
    var name: Observable<String?> {
        return nameSubject
    }

    private let nameSubject = BehaviorSubject<String?>(value: nil)
    private let disposeBag = DisposeBag()

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
        let output = router.showModalTextField(name: try? nameSubject.value())
        output.username.subscribe(onNext: { [weak self] username in
            self?.nameSubject.onNext(username)
        }).disposed(by: disposeBag)
    }

    func add() {
    }

    func tappedCloseButton() {
        router.dismiss()
    }

    func dismiss() {
        router.dismiss()
    }
}

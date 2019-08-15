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
    var icon: Observable<UIImage?> {
        return iconSubject
    }
    var name: Observable<String?> {
        return nameSubject
    }

    private let iconSubject = BehaviorSubject<UIImage?>(value: nil)
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
    private var output: PhotoLibraryPickerOutputProtocol? // 参照カウンタを一つ上げたるため

    init(router: AddUserManuallyRouterProtocol) {
        self.router = router
    }

    func showAlbum() {
        output = router.showAlbum()
        output?.image.subscribe(onNext: { [weak self] image in
            self?.iconSubject.onNext(image)
        }).disposed(by: disposeBag)
    }

    func showModalTextField() {
        let input = EditUsernameInput(username: try? nameSubject.value())
        let output = router.showModalTextField(input: input)

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

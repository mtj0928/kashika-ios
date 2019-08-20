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
        return iconSubject.asObservable()
    }
    var name: Observable<String?> {
        return nameSubject.asObservable()
    }

    private let iconSubject = BehaviorRelay<UIImage?>(value: nil)
    private let nameSubject = BehaviorRelay<String?>(value: nil)
    private let disposeBag = DisposeBag()

    private(set) lazy var isEnableToAdd: Observable<Bool>? = { [weak self] in
        guard let `self` = self else {
            return nil
        }

        return Observable.zip(self.icon, self.name).map {
            $0 != nil && $1 != nil
        }
    }()

    private let interactor: AddUserManuallyInteractorProtocol
    private let router: AddUserManuallyRouterProtocol
    private var output: PhotoLibraryPickerOutputProtocol? // 参照カウンタを一つ上げたるため

    init(interactor: AddUserManuallyInteractorProtocol, router: AddUserManuallyRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func showAlbum() {
        output = router.showAlbum()
        output?.image.subscribe(onNext: { [weak self] image in
            self?.iconSubject.accept(image)
        }).disposed(by: disposeBag)
    }

    func showModalTextField() {
        let input = EditUsernameInput(username: nameSubject.value)
        let output = router.showModalTextField(input: input)

        output.username.subscribe(onNext: { [weak self] username in
            self?.nameSubject.accept(username)
        }).disposed(by: disposeBag)
    }

    func add() {
        let name = nameSubject.value ?? "名前"
        interactor.addUser(name: name, icon: iconSubject.value)
            .filter({ $0.progress == nil })
            .asSingle()
            .asCompletable()
            .subscribe({ [weak self] _ in
                self?.router.dismiss()
            }).disposed(by: disposeBag)
    }

    func tappedCloseButton() {
        router.dismiss()
    }

    func dismiss() {
        router.dismiss()
    }
}

//
//  AddUserManuallyContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddUserManuallyPresenterProtocol {
    var icon: Observable<UIImage?> { get }
    var name: Observable<String?> { get }
    var isEnableToAdd: Observable<Bool> { get }
    var output: Observable<AddUserOutputProtocol> { get }

    func showAlbum()
    func showModalTextField()
    func add()
    func tappedCloseButton()
    func dismiss()
}

protocol AddUserManuallyRouterProtocol {
    func showAlbum() -> PhotoLibraryPickerOutputProtocol
    func showModalTextField(input: EditUsernameInputProtocol) -> EditUsernameOutputProtocol
    func dismiss()
}

protocol AddUserManuallyInteractorProtocol {
    func addUser(name: String, icon: UIImage?) -> MonitorObservable<Friend?>
}

protocol AddUserOutputProtocol {
    var monitor: MonitorObservable<Friend?> { get }
}

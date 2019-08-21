//
//  AddUserManualyViewBuilder.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import FloatingPanel

struct AddUserManualyViewBuilder {

    static func build() -> (viewController: UIViewController, output: Observable<AddUserOutputProtocol>) {
        let interactor = AddUserManuallyInteractor()
        let router = AddUserManuallyRouter()
        let presenter = AddUserManuallyPresenter(interactor: interactor, router: router)
        let viewController = AddUserManuallyViewController.createFromStoryboard(with: presenter)
        router.viewController = viewController

        let floatingPanelConoller = FloatingPanelBuilder.build()
        floatingPanelConoller.delegate = viewController
        floatingPanelConoller.set(contentViewController: viewController)

        return (floatingPanelConoller, presenter.output)
    }
}

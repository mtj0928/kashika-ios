//
//  AddDebtViewBuilder.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/05.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa
import FloatingPanel

final class AddDebtViewBuilder {

    static func build(canFloatingPanelShow: BehaviorRelay<Bool>, from rootViewController: UIViewController?) -> (viewController: UIViewController, output: Observable<AddDebtOutputProtocol>) {
        let interactor = AddDebtInteractor()
        let router = AddDebtRouter()
        let presenter = AddDebtPresenter(canFloatingPanelShow, interactor: interactor, router: router)
        let viewController = AddDebtViewController.createFromStoryboard(presenter: presenter)
        router.viewController = viewController
        router.rootViewController = rootViewController
        viewController.view.backgroundColor = UIColor.app.floatingPanelBackgroundColor

        let floatingPanelController = FloatingPanelBuilder.build()

        floatingPanelController.delegate = viewController
        floatingPanelController.set(contentViewController: viewController)
        floatingPanelController.track(scrollView: viewController.scrollView)

        return (floatingPanelController, presenter.output)
    }
}

//
//  AddDebtViewBuilder.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/05.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxCocoa
import FloatingPanel

final class AddDebtViewBuilder {

    static func build(_ canShowFloatingPannel: BehaviorRelay<Bool>) -> UIViewController {
        let router = AddDebtRouter()
        let presenter = AddDebtPresenter(canShowFloatingPannel, router: router)
        let viewController = AddDebtViewController.createFromStoryboard(presenter: presenter)
        router.viewController = viewController

        let floatingPanelController = FloatingPanelController()
        floatingPanelController.backdropView.backgroundColor = UIColor.app.secondarySystemBackground

        floatingPanelController.delegate = viewController
        floatingPanelController.surfaceView.cornerRadius = 24.0
        floatingPanelController.isRemovalInteractionEnabled = true
        floatingPanelController.set(contentViewController: viewController)

        return floatingPanelController
    }
}

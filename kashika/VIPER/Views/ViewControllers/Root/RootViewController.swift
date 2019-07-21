//
//  RootViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ESTabBarController
import FloatingPanel
import TapticEngine

final class RootViewController: ESTabBarController {

    private var presenter: RootPresenterProtocol!
    private let disposeBag = DisposeBag()

    // viewDidLoad() of UITabbarController is started when it is made.
    func setup(presenter: RootPresenterProtocol) {
        self.presenter = presenter

        setupTabbar()
    }
}

// MARK: - Set Up

extension RootViewController {

    private func setupTabbar() {
        shouldHijackHandler = { tabbarController, viewController, index in
            return index == 2
        }

        didHijackHandler = { [weak self] tabbarController, viewController, index in
            guard let `self` = self else {
                return
            }
            if !self.presenter.canShowFloatingPannel.value {
                self.presentFloatingPanel()
                return
            }
            self.presenter.canShowFloatingPannel
                .filter({ !$0 })
                .take(1)
                .subscribe(onNext: { _ in
                    self.presentFloatingPanel()
                }).disposed(by: self.disposeBag)
        }
    }

    private func presentFloatingPanel() {
        TapticEngine.impact.feedback(.medium)
        presenter.showFloatingPannel()
    }
}

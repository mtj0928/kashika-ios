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
import SwiftMessages

final class RootViewController: ESTabBarController {

    private var presenter: RootPresenterProtocol!
    private let disposeBag = DisposeBag()

    // viewDidLoad() of UITabbarController is started when it is made.
    func setup(presenter: RootPresenterProtocol) {
        self.presenter = presenter

        setupTabbar()
        setupMessageView()
    }
}

// MARK: - Set Up

extension RootViewController {

    var iconLength: CGFloat {
        return 50.0
    }

    private func setupMessageView() {
        presenter.messages
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [weak self] notification in
                guard let `self` = self else {
                    return
                }
                var config = SwiftMessages.Config()
                config.presentationContext = .window(windowLevel: .statusBar)

                let view = MessageView.viewFromNib(layout: .cardView)

                view.configureTheme(backgroundColor: UIColor.app.notificationColor, foregroundColor: UIColor.app.label)
                view.configureDropShadow()

                view.titleLabel?.text = notification.title
                view.bodyLabel?.text = notification.body
                view.button?.isHidden = true

                view.configureIcon(withSize: CGSize(width: self.iconLength, height: self.iconLength))
                view.iconImageView?.isHidden = false
                view.iconImageView?.layer.cornerRadius = self.iconLength / 2
                view.iconImageView?.sd_setImage(with: notification.url)
                view.iconImageView?.contentMode = .scaleAspectFill
                view.iconImageView?.backgroundColor = UIColor.lightGray

                if SwiftMessages.sharedInstance.current() != nil {
                    SwiftMessages.hide()
                }
                TapticEngine.impact.feedback(.medium)
                SwiftMessages.show(config: config, view: view)
            }).disposed(by: disposeBag)

    }

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

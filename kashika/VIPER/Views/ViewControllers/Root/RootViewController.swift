//
//  RootViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import ESTabBarController
import FloatingPanel

final class RootViewController: ESTabBarController {

    typealias Presenter = RootPresenterProtocol

    private var presenter: Presenter!
    private var floatingPanelController: FloatingPanelController?

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        floatingPanelController?.removePanelFromParent(animated: true)
    }

    // viewDidLoad() of UITabbarController is started when it is made.
    func setup(presenter: Presenter) {
        self.presenter = presenter

        setupTabbar()
        setupFloatingPanel()
    }
}

// MARK: - Set Up

extension RootViewController {

    private func setupTabbar() {
        shouldHijackHandler = { tabbarController, viewController, index in
            return index == 2
        }

        didHijackHandler = { [weak self] tabbarController, viewController, index in
            guard let `self` = self, let floatingPanelController = self.floatingPanelController else {
                return
            }
            self.present(floatingPanelController, animated: true, completion: nil)
        }
    }

    private func setupFloatingPanel() {
        floatingPanelController = FloatingPanelController()

        let contentViewController = ViewController()
        floatingPanelController?.set(contentViewController: contentViewController)

        floatingPanelController?.surfaceView.cornerRadius = 24.0
        floatingPanelController?.delegate = self
        floatingPanelController?.isRemovalInteractionEnabled = true
    }
}

// MARK: - FloatingPanelDelegate

extension RootViewController: FloatingPanelControllerDelegate {

    func floatingPanel(_ viewController: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return EditDebtLayout()
    }
}

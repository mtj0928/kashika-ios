//
//  AddUserManualyViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import FloatingPanel
import TapticEngine

final class AddUserManuallyViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var placeHolder: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!

    private var presenter: AddUserManuallyPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupImageView()
        nameLabel.isHidden = !false
        placeHolder.isHidden = !nameLabel.isHidden
    }

    @IBAction func tappedSetImageButton() {
        presenter.showAlbum()
    }

    @IBAction func tappedSetUserNameButton() {
        presenter.showModalTextField()
    }

    @IBAction func tappedAddButton() {
        presenter.add()
    }

    @IBAction func tappedCloseButton() {
        TapticEngine.impact.feedback(.light)
        presenter.tappedCloseButton()
    }

    static func createFromStoryboard(with presenter: AddUserManuallyPresenterProtocol) -> AddUserManuallyViewController {
        let viewController = createFromStoryboard()
        viewController.presenter = presenter
        return viewController
    }
}

// MARK: - Set Up

extension AddUserManuallyViewController {

    private func setupImageView() {
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.backgroundColor = UIColor.lightGray
    }
}

// MARK: - FloatingPanelControllerDelegate

extension AddUserManuallyViewController: FloatingPanelControllerDelegate {

    func floatingPanel(_ viewController: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return AddUserManualyLayout()
    }

    func floatingPanelDidEndDecelerating(_ viewController: FloatingPanelController) {
        if viewController.position == .hidden {
            // TODO: Presenterに処理を委譲させる
            dismiss(animated: true, completion: nil)
        }
    }
}

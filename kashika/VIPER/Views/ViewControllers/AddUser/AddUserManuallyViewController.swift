//
//  AddUserManualyViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FloatingPanel
import TapticEngine

final class AddUserManuallyViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var placeHolder: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addButton: EmphasisButton!

    private var presenter: AddUserManuallyPresenterProtocol!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupImageView()
        setupTextLabel()
        setupAddButton()
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

        presenter.icon.subscribe(onNext: { [weak self] image in
            self?.imageView.image = image
        }).disposed(by: disposeBag)
    }

    private func setupAddButton() {
        presenter.isEnableToAdd
            .map({ $0 ? UIColor.app.saveButtonColor : UIColor.app.nonActiveButtonColor })
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [weak self] color in
                self?.addButton.backgroundColor = color
            }).disposed(by: disposeBag)

        presenter.isEnableToAdd
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [weak self] isEnableToAdd in
                self?.addButton.isUserInteractionEnabled = isEnableToAdd
            }).disposed(by: disposeBag)
    }

    private func setupTextLabel() {
        presenter.name.asDriver(onErrorDriveWith: Driver.empty()).drive(onNext: { [weak self] text in
            self?.nameLabel.text = text
        }).disposed(by: disposeBag)

        presenter.name
            .map({ $0 ?? "" })
            .map({ $0.isEmpty })
            .share()
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [weak self] value in
                self?.placeHolder.isHidden = !value
                self?.nameLabel.isHidden = value
            }).disposed(by: disposeBag)
    }
}

// MARK: - FloatingPanelControllerDelegate

extension AddUserManuallyViewController: FloatingPanelControllerDelegate {

    func floatingPanel(_ viewController: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        viewController.surfaceView.backgroundColor = view.backgroundColor
        viewController.surfaceView.containerView.backgroundColor = view.backgroundColor
        return AddUserManualyLayout()
    }

    func floatingPanelDidEndDecelerating(_ viewController: FloatingPanelController) {
        if viewController.position == .hidden {
            presenter.dismiss()
        }
    }
}

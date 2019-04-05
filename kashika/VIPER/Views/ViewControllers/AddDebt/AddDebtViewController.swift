//
//  AddDebtViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/04.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

final class AddDebtViewController: UIViewController {

    @IBOutlet private weak var closeButton: UIButton!

    private var presenter: AddDebtPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func tappedCloseButton(_ sender: UIButton) {
        presenter.tappedCloseButton()
    }

    class func createFromStoryboard(presenter: AddDebtPresenterProtocol) -> AddDebtViewController {
        let viewController = createFromStoryboard()
        viewController.presenter = presenter
        return viewController
    }
}

// MARK: - Set Up

extension AddDebtViewController {

}

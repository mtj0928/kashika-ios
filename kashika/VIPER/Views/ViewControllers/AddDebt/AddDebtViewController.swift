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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func tapedCloseButton(_ sender: UIButton) {
        // TODO: - 本来は view -> presenter -> router と流れるべき
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Set Up

extension AddDebtViewController {

}

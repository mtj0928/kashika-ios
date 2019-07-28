//
//  AddUserManuallyRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class AddUserManuallyRouter: AddUserManuallyRouterProtocol {

    weak var viewController: UIViewController?

    func showAlbum() {
    }

    func showModalTextField() {
    }

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}

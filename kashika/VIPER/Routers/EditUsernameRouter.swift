//
//  EditUsernameRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/29.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class EditUsernameRouter: EditUsernameRouterProtocol {

    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}

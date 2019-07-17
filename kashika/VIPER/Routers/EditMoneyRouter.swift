//
//  EditMoneyRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/17.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxCocoa

final class EditMoneyRouter: EditMoneyRouterProtocol {

    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}

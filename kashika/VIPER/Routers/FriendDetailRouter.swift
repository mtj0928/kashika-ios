//
//  FriendDetailRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/25.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class FriendDetailRouter: FriendDetailRouterProtocol {

    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func tapDetail(fot debt: Debt) {
    }
}

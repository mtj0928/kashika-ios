//
//  SelectLinkFriendRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/09/15.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class SelectLinkFriendRouter: SimpleFriendListRouterProtocol {

    weak var viewController: UIViewController?
    var completion: ((Bool) -> Void)?

    func select(_ friend: Friend) {
        let completion = self.completion
        viewController?.dismiss(animated: true) {
            completion?(true)
        }
    }

    func close() {
        let completion = self.completion
        viewController?.dismiss(animated: true) {
            completion?(false)
        }
    }
}

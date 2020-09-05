//
//  ConfirmationInviteRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/26.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import UIKit

class ConfirmationInviteRouter: ConfirmationInviteRouterProtocol {

    weak var view: PopupView?

    func dismiss() {
        view?.dismiss()
        view?.removeFromSuperview()
    }
}

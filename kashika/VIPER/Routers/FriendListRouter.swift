//
//  FriendListRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/26.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift

class FriendListRouter: FriendListRouterProtocol {

    weak var viewController: UIViewController?

    func shoUserDetailView() {
    }
}

// MARK: - SNSFooterRouterProtocol

extension FriendListRouter: SNSFooterRouterProtocol {

    func showUserAddView(with type: UserAdditionType) -> Observable<AddUserOutputProtocol>? {
        switch type {
        case .manual:
            return showAddUserManualyView()
        case .sns:
            return nil
        }
    }

    private func showAddUserManualyView() -> Observable<AddUserOutputProtocol> {
        let build = AddUserManualyViewBuilder.build()
        self.viewController?.present(build.viewController, animated: true)
        return build.output
    }
}

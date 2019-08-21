//
//  SNSFooterContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/20.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift

enum UserAdditionType {
    case manual, sns
}

protocol SNSFooterPresenterProtocol {
    func tappedAddUserButton(with: UserAdditionType)
}

protocol SNSFooterRouterProtocol {
    func showUserAddView(with: UserAdditionType) -> AddUserOutputProtocol?
}

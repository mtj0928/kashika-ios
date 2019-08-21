//
//  SNSFooterContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/20.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift

enum UserAdditionType {
    case manual, sns
}

protocol SNSFooterPresenterProtocol {
    var isSendingData: Observable<Bool> { get }
    var progress: Observable<Progress?> { get }
    
    func tappedAddUserButton(with: UserAdditionType)
}

protocol SNSFooterRouterProtocol {
    func showUserAddView(with: UserAdditionType) -> Observable<AddUserOutputProtocol>?
}

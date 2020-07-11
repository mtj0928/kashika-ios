//
//  RootRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/21.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RootRouter: RootRouterProtocol {

    weak var viewController: UIViewController?

    func showFloatingPannel(_ canFloatingPanelShow: BehaviorRelay<Bool>) -> Observable<AddDebtOutputProtocol> {
        let buildResult = AddDebtViewBuilder.build(canFloatingPanelShow: canFloatingPanelShow, from: viewController)
        viewController?.present(buildResult.viewController, animated: true)
        return buildResult.output
    }
}

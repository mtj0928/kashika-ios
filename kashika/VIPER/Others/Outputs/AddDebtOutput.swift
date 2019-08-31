//
//  AddDebtOutput.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/30.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift

struct AddDebtOutput: AddDebtOutputProtocol {
    let debts: Single<[Debt]>
}

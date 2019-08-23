//
//  AddUserManuallyOutput.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/21.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift

struct AddUserManuallyOutput: AddUserOutputProtocol {
    let monitor: MonitorObservable<Friend?>
}

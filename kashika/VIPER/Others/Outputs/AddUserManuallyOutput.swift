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
    let isSendingData: Observable<Bool>
    let progress: Observable<Progress?>
    let monitor: MonitorObservable<Friend> = Observable.empty()

    init() {
        progress = monitor.map({ $0.progress }).share()
        isSendingData = progress.map({ $0 != nil })
    }
}

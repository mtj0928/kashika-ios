//
//  DebtsPool.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/09.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa
import Ballcap

class Pool<T: Modelable & Codable> {
    var value: [Document<T>] {
        dataSource?.documents ?? []
    }
    var observable: Observable<[Document<T>]> {
        subject
    }
    private let subject = BehaviorSubject<[Document<T>]>(value: [])
    private var nowListeningUser: Document<User>?
    private var dataSource: DataSource<Document<T>>?
    private var disposeBag = RxSwift.DisposeBag()

    func listen(user: Document<User>, dataSource: DataSource<Document<T>>) {
        guard user.id != nowListeningUser?.id else {
            return
        }
        nowListeningUser = user

        disposeBag = DisposeBag()

        self.dataSource?.stop()
        self.dataSource = dataSource.onChanged { [weak self] (_, _) in
            self?.subject.onNext(dataSource.documents)
        }.listen()
    }

    func stop() {
        subject.onNext([])
        nowListeningUser = nil
        disposeBag = RxSwift.DisposeBag()
    }
}

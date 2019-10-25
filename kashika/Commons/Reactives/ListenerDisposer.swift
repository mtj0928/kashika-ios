//
//  Relay.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/10/22.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa
import Ballcap

class ListenerDisposer<T, Listener: kashika.Listener> {
    let behaviorRelay: BehaviorRelay<T>
    private let listener: Listener

    private let disposeBag = RxSwift.DisposeBag()

    init(_ observable: Observable<T>, initialValue: T, listener: Listener) {
        behaviorRelay = BehaviorRelay(value: initialValue)
        self.listener = listener
        observable.subscribe(onNext: { [weak self] value in
            self?.behaviorRelay.accept(value)
        }).disposed(by: disposeBag)
    }

    init<U>(_ observable: Observable<U>, initialValue: U, listener: Listener, _ mapper: @escaping (U) -> T) {
        behaviorRelay = BehaviorRelay(value: mapper(initialValue))
        self.listener = listener
        observable.subscribe(onNext: { [weak self] value in
            self?.behaviorRelay.accept(mapper(value))
        }).disposed(by: disposeBag)
    }

    convenience init<U>(_ listener: DocumentListener<U>) where U: Modelable & Codable, T == Document<U>?, Listener == DocumentListener<U> {
        self.init(listener.obserbavle, initialValue: listener.value, listener: listener)
    }

    convenience init<U>(_ listener: DocumentListener<U>, _ mapper: @escaping (Document<U>?) -> T) where U: Modelable & Codable, Listener == DocumentListener<U> {
        self.init(listener.obserbavle, initialValue: listener.value, listener: listener, mapper)
    }

    convenience init<U>(_ listener: DocumentsListener<U>) where T == [Document<U>], Listener == DocumentsListener<U> {
        self.init(listener.obserbavle, initialValue: listener.value, listener: listener)
    }

    convenience init<U>(_ listener: DocumentsListener<U>, _ mapper: @escaping ([Document<U>]) -> T) where Listener == DocumentsListener<U> {
        self.init(listener.obserbavle, initialValue: listener.value, listener: listener, mapper)
    }
}

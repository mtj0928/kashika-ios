//
//  RxPublished.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/17.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

@propertyWrapper
struct RxPublished<Value>: RxSubject {

    var wrappedValue: Observable<Value> {
        publishedSubject
    }

    private let publishedSubject = PublishSubject<Value>()

    func on(_ event: Event<Value>) {
        publishedSubject.on(event)
    }
}

@propertyWrapper
struct RxBehavior<Value>: RxSubject {

    var wrappedValue: Observable<Value> {
        behaviorSubject
    }

    private let behaviorSubject: BehaviorSubject<Value>

    init(value: Value) {
        behaviorSubject = BehaviorSubject(value: value)
    }

    func on(_ event: Event<Value>) {
        behaviorSubject.on(event)
    }
}

// MARK: - Protocol

protocol RxSubject {

    associatedtype Value

    func on(_ event: Event<Value>)
}

extension RxSubject {
    func onNext(_ value: Value) {
        on(.next(value))
    }

    func onCompleted() {
        on(.completed)
    }

    func onError(_ error: Error) {
        on(.error(error))
    }
}

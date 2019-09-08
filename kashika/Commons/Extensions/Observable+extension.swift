//
//  Observable+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/07.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift

protocol Optionable {
    associatedtype Wrapped
    func flatMap<U>(_ transform: (Wrapped) throws -> U?) rethrows -> U?
}

extension Optional: Optionable {}

extension ObservableType {

    func filterNil<T>() -> Observable<T> where E == T? {
        return filter({ ($0 as T?) != nil })
            .map({ $0.unsafelyUnwrapped })
    }

    func onlyNil<T>() -> Observable<Void> where E == T? {
        return filter({ ($0 as T?) == nil })
            .map({ _ in Void() })
    }
}

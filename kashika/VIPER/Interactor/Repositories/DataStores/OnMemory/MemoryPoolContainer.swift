//
//  MemoryPoolContainer.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/24.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

final class MemoryPoolContainer {
    static var `default` = MemoryPoolContainer()

    private var instances = [ObjectIdentifier: Any]()
    private let locker = NSRecursiveLock()

    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        locker.lock()
        defer { locker.unlock() }

        let key = ObjectIdentifier(type)
        instances[key] = factory() as Any
    }

    func resolve<T>(_ type: T.Type, ifNotExists factory: @escaping () -> T) -> T {
        locker.lock()
        defer { locker.unlock() }

        let key = ObjectIdentifier(type)
        if let instance = instances[key] as? T {
            return instance
        }

        let instance = factory()
        instances[key] = instance as Any
        return instance
    }
}

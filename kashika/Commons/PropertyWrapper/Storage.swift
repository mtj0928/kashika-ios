//
//  Storage.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/21.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

enum StorageKey: String, CaseIterable {
    case popupLink
}

@propertyWrapper
struct Storage<Value> {
    private let key: StorageKey

    var wrappedValue: Value {
        get {
            UserDefaults.standard.object(forKey: key.rawValue) as? Value ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        }
    }

    private let defaultValue: Value

    init(_ key: StorageKey, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

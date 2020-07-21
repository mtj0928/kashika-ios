//
//  Storage.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/21.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

@propertyWrapper
struct Storage<Value> {

    enum Key: String {
        case popupLink
    }

    private let key: Key

    var wrappedValue: Value {
        get {
            UserDefaults.standard.object(forKey: key.rawValue) as? Value ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        }
    }

    private let defaultValue: Value

    init(_ key: Key, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

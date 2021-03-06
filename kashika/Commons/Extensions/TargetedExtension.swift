//
//  TargetedExtension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

struct TargetedExtension<Base> {
    let base: Base
    init (_ base: Base) {
        self.base = base
    }
}

protocol TargetedExtensionCompatible {
    associatedtype Compatible
    static var ex: TargetedExtension<Compatible>.Type { get }
    var ex: TargetedExtension<Compatible> { get }
}

extension TargetedExtensionCompatible {
    static var ex: TargetedExtension<Self>.Type {
        return TargetedExtension<Self>.self
    }

    var ex: TargetedExtension<Self> {
        return TargetedExtension(self)
    }
}

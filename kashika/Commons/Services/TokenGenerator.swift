//
//  TokenGenerator.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/17.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

typealias Token = String

extension Token {

    static private var base: Token {
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    }

    static func generate(length: Int) -> Token {
        (0..<length).map { _ in arc4random_uniform(UInt32(base.count)) }
            .map { "\(base[base.index(base.startIndex, offsetBy: Int($0))])" }
            .joined()
    }
}

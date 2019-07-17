//
//  String+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/17.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

extension String {

    static func convertWithComma(from value: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let commaString = formatter.string(from: NSNumber(value: value))
        return commaString
    }
}

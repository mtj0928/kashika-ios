//
//  URL+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/19.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

// MARK: - Query

extension URL {

    var queries: [String: String] {
        URLComponents(string: absoluteString)?
            .queryItems?
            .reduce([String: String]()) { (result, item) in
                var result = result
                result[item.name] = item.value
                return result
            }
            ?? [:]
    }

    func appendQuery(name: String, value: String?) -> URL? {
        return self.appendQueries([URLQueryItem(name: name, value: value)])
    }

    func appendQueries(_ queryItems: [URLQueryItem]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: nil != self.baseURL) else {
            return nil
        }
        components.queryItems = queryItems + (components.queryItems ?? [])
        return components.url
    }

}

// MARK: - Deeplink

extension URL {

    var deeplinkType: DeeplinkType? {
        get {
            guard let query = queries["deeplink_type"] else {
                return nil
            }
            return DeeplinkType(rawValue: query)
        }
        set {
            self = self.appendQuery(name: "deeplink_type", value: newValue?.rawValue) ?? self
        }
    }

    func setDeeplink(_ type: DeeplinkType?) -> URL {
        var url = self
        url.deeplinkType = deeplinkType
        return url
    }
}

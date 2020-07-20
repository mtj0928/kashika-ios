//
//  URL+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/19.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

extension URL {

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

//
//  CallableFunctions.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/24.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import FirebaseFunctions
import RxSwift

enum CallbleError: Error {
    case parseError
}

protocol CallableFunctions {
    associatedtype Input: Encodable
    associatedtype Output: Decodable

    static var name: String { get }
}

extension CallableFunctions {

    static func call(_ input: Input) -> Single<Output> {
        return Single.create { observer in
            guard let data = try? JSONEncoder().encode(input),
                let object = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    observer(.error(CallbleError.parseError))
                    return Disposables.create()
            }

            Functions.functions()
                .httpsCallable(Self.name)
                .call(object) { (result, error) in
                    if let error = error {
                        observer(.error(error))
                        return
                    }

                    guard let result = result,
                        let data = try? JSONSerialization.data(withJSONObject: result.data, options: []),
                        let object = try? JSONDecoder().decode(Output.self, from: data) else {
                            observer(.error(CallbleError.parseError))
                            return
                    }
                    observer(.success(object))
            }
            return Disposables.create()
        }
    }
}

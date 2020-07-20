//
//  DynamicLinkComponents+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/19.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

extension DynamicLinkComponents: TargetedExtensionCompatible {
}

extension TargetedExtension where Base: DynamicLinkComponents {

    func shorten() -> Single<URL> {
        Single.create { observer -> Disposable in
            self.base.iOSParameters = DynamicLinkIOSParameters(bundleID: Bundle.main.bundleIdentifier!)
            self.base.shorten { (shortURL, _, error) in
                guard let shortURL = shortURL else {
                    if let error = error {
                        print(error.localizedDescription)
                        observer(.error(error))
                    }
                    return
                }
                observer(.success(shortURL))
            }
            return Disposables.create()
        }
    }
}

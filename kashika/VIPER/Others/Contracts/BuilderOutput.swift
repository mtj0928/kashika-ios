//
//  BuilderOutput.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/04.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift

struct BuilderOutput<ViewController: UIViewController, Output> {
    let viewController: ViewController
    let output: Observable<Output>
}

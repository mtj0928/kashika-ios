//
//  PhotoLibraryPickerContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift

protocol PhotoLibraryPickerOutputProtocol {
    var image: Observable<UIImage?> { get }
}

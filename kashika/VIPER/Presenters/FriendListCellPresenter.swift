//
//  FriendListCellPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/18.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import Firebase

protocol FriendListCellPresenterProtocol {
    var name: Observable<String> { get }
    var iconURL: Observable<URL?> { get }
    var plaveHolderImage: Observable<UIImage?> { get }
    var debt: Observable<Int> { get }
    var isKari: Observable<Bool> { get }
    var isKashi: Observable<Bool> { get }
    var hasNoDebt: Observable<Bool> { get }
}

struct FriendListCellPresenter: FriendListCellPresenterProtocol {
    let name: Observable<String>
    let iconURL: Observable<URL?>
    let plaveHolderImage: Observable<UIImage?> = BehaviorSubject(value: nil)
    let debt: Observable<Int>
    let isKari: Observable<Bool>
    let isKashi: Observable<Bool>
    let hasNoDebt: Observable<Bool>

    init(_ friend: Friend) {
        name = BehaviorSubject(value: friend.name)
        iconURL = BehaviorSubject(value: friend.iconFile?.url)
        debt = BehaviorSubject(value: Int(friend.totalDebt.rawValue))
        isKari = debt.map { $0 > 0 }
        isKashi = debt.map { $0 < 0 }
        hasNoDebt = debt.map { $0 == 0 }
    }
}

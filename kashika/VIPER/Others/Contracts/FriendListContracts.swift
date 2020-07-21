//
//  FriendListContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/24.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum FriendListViewState {
    case normal, showIndicartor
}

protocol FriendListPresenterProtocol {
    var friends: BehaviorRelay<[Friend]> { get }
    var sharedItem: Observable<InviteActivityItemSource> { get }
    var shouldShowPopup: Bool { get set }

    func tapped(friend: Friend)
    func tappedLinkButton(friend: Friend)
}

protocol FriendListInteractorProtocol {
    var friends: BehaviorRelay<[Friend]> { get }

    func createShardURL(for friend: Friend) -> Single<URL>
}

protocol FriendListRouterProtocol {
    func showDetailView(for friend: Friend)
}

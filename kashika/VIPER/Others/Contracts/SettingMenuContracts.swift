//
//  SettingMenuContracts.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/25.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

enum SettingMenuSection: String {
    case about = "このアプリについて"
    case debug = "デバッグメニュー"
}

enum SettingMenuItem: String, CaseIterable {
    case about = "このアプリについて"
    case inquiry = "お問い合わせ"
    case copyright = "著作権表示"
    case signout = "サインアウト"
    case deleteFriends = "友達を削除"
}

protocol SettingMenuInputProtocol {
    var sections: [SettingMenuSection] { get }
}

protocol SettingMenuPresenterProtocol {
    var sections: BehaviorRelay<[SettingMenuSection]> { get }

    func sectionTitle(for: SettingMenuSection) -> String?
    func countRows(for: SettingMenuSection) -> Int
    func title(at index: Int, for: SettingMenuSection) -> String
    func tapped(at index: Int, for section: SettingMenuSection)
}

protocol SettingMenuInteractorProtocol {
    func signout() -> Completable
    func deleteFriends() -> Completable
}

protocol SettingMenuRouterProtocol {
    func push(for: SettingMenuItem)
}

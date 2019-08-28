//
//  SettingMenuPresenter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/25.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import RxSwift
import RxCocoa

class SettingMenuPresenter: SettingMenuPresenterProtocol {

    let sections: BehaviorRelay<[SettingMenuSection]>

    private let rows: [SettingMenuSection: [SettingMenuItem]] = [
        .about: [.about, .inquiry, .copyright],
        .debug: [.deleteFriends, .signout]
    ]
    private let interactor: SettingMenuInteractorProtocol
    private let router: SettingMenuRouterProtocol
    private let disposeBag = DisposeBag()

    init(input: SettingMenuInputProtocol, interactor: SettingMenuInteractorProtocol, router: SettingMenuRouterProtocol) {
        sections = BehaviorRelay(value: input.sections)
        self.interactor = interactor
        self.router = router
    }

    func sectionTitle(for section: SettingMenuSection) -> String? {
        return section.rawValue
    }

    func countRows(for section: SettingMenuSection) -> Int {
        return rows[section]?.count ?? 0
    }

    func title(at index: Int, for section: SettingMenuSection) -> String {
        return rows[section]?[index].rawValue ?? ""
    }

    func tapped(at index: Int, for section: SettingMenuSection) {
        guard let item = rows[section]?[index] else {
            return
        }
        
        if item == .signout {
            interactor.signout()
                .subscribe().disposed(by: disposeBag)
        } else if item == .deleteFriends {
            interactor.deleteFriends()
                .subscribe().disposed(by: disposeBag)
        }

        if section == .about {
            router.push(for: item)
        }
    }
}

//
//  CalendarViewBuilder.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/04.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

struct CalendarViewBuilder {

    static func build() -> BuilderOutput<CalendarViewController, CalendarOutputProtocol> {
        let presenter = CalendarPresenter()
        let viewController = CalendarViewController.createFromStoryboard(with: presenter)
        return BuilderOutput(viewController: viewController, output: presenter.output)
    }
}

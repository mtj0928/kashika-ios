//
//  FloatingPanelBuilder.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import FloatingPanel

class FloatingPanelBuilder {

    static func build() -> FloatingPanelController {
        let floatingPanelController = FloatingPanelController()
        floatingPanelController.backdropView.backgroundColor = UIColor.black

        floatingPanelController.surfaceView.cornerRadius = 24.0
        floatingPanelController.isRemovalInteractionEnabled = true
        floatingPanelController.surfaceView.backgroundColor = UIColor.app.systemBackground

        return floatingPanelController
    }
}

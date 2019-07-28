//
//  AddUserManualyLayout.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import FloatingPanel

class AddUserManualyLayout: FloatingPanelLayout {

    let initialPosition: FloatingPanelPosition = .half
    let supportedPositions: Set<FloatingPanelPosition> = Set([.half, .hidden])
    var topInteractionBuffer: CGFloat = 200

    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        if position == .half {
            return FloatingPanelConfiguration.insetForHalf
        }
        return nil
    }

    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        if position == .half {
            return FloatingPanelConfiguration.backgroundAlphaForHalf
        }
        return CGFloat.zero
    }
}

//
//  WarikanSettingLayout.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/30.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import FloatingPanel

class WarikaneSettingLayout: FloatingPanelLayout {

    let initialPosition: FloatingPanelPosition = .full
    let supportedPositions: Set<FloatingPanelPosition> = Set([.full, .hidden])

    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        if position == .full {
            return FloatingPanelConfiguration.insetForFull
        } else if position == .half {
            return FloatingPanelConfiguration.insetForHalf
        }
        return nil
    }

    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        switch position {
        case .full:
            return FloatingPanelConfiguration.backgroundAlphaForFull
        default:
            return CGFloat.zero
        }
    }
}

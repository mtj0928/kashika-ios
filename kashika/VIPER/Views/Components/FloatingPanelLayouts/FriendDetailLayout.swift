//
//  FriendDetailLayout.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/25.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import FloatingPanel

class FriendDetailLayout: FloatingPanelLayout {

    let initialPosition: FloatingPanelPosition = .half
    let supportedPositions: Set<FloatingPanelPosition> = Set([.full, .half, .hidden])
    let topInteractionBuffer: CGFloat = 0.0

    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
            return FloatingPanelConfiguration.insetForFull
        case .half:
            return FloatingPanelConfiguration.insetForHalf + 40.0
        default:
            return nil
        }
    }

    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        switch position {
        case .full:
            return FloatingPanelConfiguration.backgroundAlphaForFull
        case .half:
            return FloatingPanelConfiguration.backgroundAlphaForHalf
        default:
            return CGFloat.zero
        }
    }
}

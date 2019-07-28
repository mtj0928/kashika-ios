//
//  EditDebtLayout.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/02.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import FloatingPanel

class EditDebtLayout: FloatingPanelLayout {

    let initialPosition: FloatingPanelPosition = .half
    let supportedPositions: Set<FloatingPanelPosition> = Set([.full, .half, .hidden])
    let topInteractionBuffer: CGFloat = 0.0

    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
            return FloatingPanelConfiguration.insetForFull
        case .half:
            return FloatingPanelConfiguration.insetForHalf
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

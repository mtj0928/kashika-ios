//
//  EditDebtLayout.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/02.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import FloatingPanel

public class EditDebtLayout: FloatingPanelLayout {

    public var initialPosition: FloatingPanelPosition {
        return .half
    }

    public var supportedPositions: Set<FloatingPanelPosition> {
        return Set([.full, .half, .hidden])
    }

    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
            return 18.0
        case .half:
            return 384.0
        default:
            return nil
        }
    }
}

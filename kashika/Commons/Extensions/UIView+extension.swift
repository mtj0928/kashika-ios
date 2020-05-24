//
//  UIView+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/20.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

extension UIView {

    func addViewWithFilling(_ view: UIView?) {
        guard let view = view else {
            return
        }
        self.addSubview(view)
        view.isUserInteractionEnabled = true
        view.fillSuperview()
    }

    func fillSuperview() {
        guard let superview = self.superview else {
            return

        }
        translatesAutoresizingMaskIntoConstraints = superview.translatesAutoresizingMaskIntoConstraints
        
        if translatesAutoresizingMaskIntoConstraints {
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
            frame = superview.bounds
        } else {
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        }
    }
}

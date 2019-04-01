//
//  TabbarButton.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import ESTabBarController

class TabbarButton: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.backgroundColor = UIColor.app.themaColor
        superview?.bringSubviewToFront(self)

        textColor = .clear
        highlightTextColor = .clear
        iconColor = .white
        highlightIconColor = .white
        backdropColor = .clear
        highlightBackdropColor = .clear
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayout() {
        super.updateLayout()
        let minSide = min(frame.height, frame.width) + 20
        imageView.frame.size = CGSize(width: minSide, height: minSide)
        imageView.center = center
        imageView.layer.cornerRadius = minSide / 2
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let diff = CGPoint(x: point.x - imageView.center.x, y: point.y - imageView.center.y)
        let flag = sqrt(pow(diff.x, 2.0) + pow(diff.y, 2.0)) < imageView.frame.size.width / 2.0
        return flag
    }

    public override func highlightAnimation(animated: Bool, completion: (() -> Void)?) {
        UIView.beginAnimations("small", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
        self.imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }

    public override func dehighlightAnimation(animated: Bool, completion: (() -> Void)?) {
        UIView.beginAnimations("big", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = CGAffineTransform.identity
        self.imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }
}

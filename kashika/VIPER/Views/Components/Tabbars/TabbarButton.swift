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

    private let buttonView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        superview?.bringSubviewToFront(self)
        self.insertSubview(buttonView, belowSubview: imageView)

        textColor = .clear
        backdropColor = .clear
        highlightTextColor = .clear
        iconColor = UIColor.app.white
        highlightIconColor = UIColor.app.white
        highlightBackdropColor = UIColor.app.white
        imageView.backgroundColor = .clear
        buttonView.backgroundColor = UIColor.app.themaColor
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayout() {
        super.updateLayout()

        let minSide = min(frame.height, frame.width) - 5
        let side = minSide + 20
        let center = CGPoint(x: self.center.x, y: self.center.y - (side - frame.height) / 2)

        buttonView.frame.size = CGSize(width: side, height: side)
        buttonView.center = center
        buttonView.layer.cornerRadius = side / 2

        imageView.frame.size = CGSize(width: minSide, height: minSide)
        imageView.center = center
        imageView.layer.cornerRadius = minSide / 2
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let diff = CGPoint(x: point.x - buttonView.center.x, y: point.y - buttonView.center.y)
        let flag = sqrt(pow(diff.x, 2.0) + pow(diff.y, 2.0)) < buttonView.frame.size.width / 2.0
        return flag
    }

    public override func highlightAnimation(animated: Bool, completion: (() -> Void)?) {
        let scale: CGFloat = 0.8
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else { return }

            [self.imageView, self.buttonView].forEach { view in
                view.transform = view.transform.scaledBy(x: scale, y: scale)
            }
        }, completion: { _ in completion?() })
    }

    public override func dehighlightAnimation(animated: Bool, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else { return }
            [self.imageView, self.buttonView].forEach { view in
                view.transform = CGAffineTransform.identity
            }
        }, completion: { _ in completion?() })
    }
}

//
//  WarikanSwitch.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/26.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxCocoa
import TapticEngine

@IBDesignable
class WarikanSwitch: UIButton {

    class RxWarikanSwitchButton {
        let isActive = BehaviorRelay(value: false)
    }

    @IBInspectable var isActive: Bool = false {
        didSet {
            update()
        }
    }

    let rx = RxWarikanSwitchButton()

    override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            effectView.isHidden = isEnabled
        }
    }
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        label.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        label.text = "割り勘"
        return label
    }()

    let effectView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.isHidden = true
        return view
    }()

    let checkMarkView: CheckMarkView = {
        let view = CheckMarkView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    private var activeConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        sharedInit()
    }
    
    private func sharedInit() {
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        checkMarkView.isUserInteractionEnabled = false
        
        addSubview(textLabel)
        addSubview(checkMarkView)
        addViewWithFilling(effectView)

        setupConstraints()
        updateActiveConstraints()
        updateView()

        TapticEngine.impact.prepare(.light)

        addTarget(self, action: #selector(self.tappedAction), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
        checkMarkView.layer.cornerRadius = checkMarkView.frame.height / 2
    }

    @objc
    private func tappedAction() {
        TapticEngine.impact.feedback(.light)
        isActive = !isActive
        rx.isActive.accept(isActive)
    }

    private func update() {
        updateActiveConstraints()
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.updateView()
            self?.layoutIfNeeded()
        }
        checkMarkView.animate(isShow: isActive)
    }
    
    private func setupConstraints() {
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkMarkView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkMarkView.heightAnchor.constraint(equalTo: checkMarkView.widthAnchor).isActive = true
        checkMarkView.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
    }
    
    private func updateActiveConstraints() {
        deactive(activeConstraints)

        if isActive {
            activeConstraints = [
                textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                checkMarkView.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 2),
                checkMarkView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6.0)
            ]
        } else {
            activeConstraints = [
                checkMarkView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6.0),
                textLabel.leadingAnchor.constraint(equalTo: checkMarkView.trailingAnchor, constant: 2),
                textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0)
            ]
        }
        active(activeConstraints)
    }

    private func updateView() {
        if isActive {
            textLabel.textColor = UIColor.white
            backgroundColor = UIColor.app.activeWarikanSwitchColor
            checkMarkView.backgroundColor = UIColor.app.activeSwitchButtonToggleColor
        } else {
            textLabel.textColor = UIColor.app.link
            backgroundColor = UIColor.app.nonActiveWarikanSwitchColor
            checkMarkView.backgroundColor = UIColor.app.noactiveSwitchButtonToggleColor
        }
    }

    private func active(_ constraints: [NSLayoutConstraint]) {
        update(constraints, isActive: true)
    }

    private func deactive(_ constraints: [NSLayoutConstraint]) {
        update(constraints, isActive: false)
    }

    private func update(_ constraints: [NSLayoutConstraint], isActive: Bool ) {
        constraints.forEach { $0.isActive = isActive }
    }
}

class CheckMarkView: UIView {

    private var pathLayer: CAShapeLayer?
    private var isShow = false

    private func updatePathLayer() {
        pathLayer?.removeFromSuperlayer()

        let pathLayer = CAShapeLayer(layer: self.layer)
        pathLayer.lineWidth = 4.0
        pathLayer.lineCap = .round
        pathLayer.path = CheckMarkView.createPath(frame).cgPath
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.systemYellow.cgColor
        layer.addSublayer(pathLayer)

        self.pathLayer = pathLayer
    }

    func animate(isShow: Bool) {
        if isShow == self.isShow {
            return
        }
        self.isShow = isShow
        updatePathLayer()

        let bounce = CABasicAnimation(keyPath: "strokeEnd")
        bounce.timingFunction = CAMediaTimingFunction(name: .easeIn)
        bounce.delegate = self
        bounce.isRemovedOnCompletion = false
        bounce.fillMode = .forwards

        bounce.fromValue = isShow ? 0 : 1.0
        bounce.toValue = isShow ? 1.0 : 0
        bounce.duration = 0.3

        self.pathLayer?.add(bounce, forKey: "return")
    }

    private static func createPath(_ rect: CGRect) -> UIBezierPath {
        let startPosition = CGPoint(x: rect.width / 4, y: 17 * rect.height / 40)
        let middlePosition = CGPoint(x: 9 * rect.width / 20, y: 2 * rect.height / 3)
        let finalposition = CGPoint(x: 7 * rect.width / 10, y: 3 * rect.height / 10)

        let line = UIBezierPath()
        line.move(to: startPosition)
        line.addLine(to: middlePosition)
        line.addLine(to: finalposition)

        line.lineWidth = 4.0
        line.lineCapStyle = .round

        return line
    }
}

extension CheckMarkView: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag && !isShow {
            pathLayer?.removeFromSuperlayer()
        }
    }
}

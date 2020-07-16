//
//  PopupView.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/14.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import ViewAnimator

@IBDesignable
class PopupView: UIView {

    var contentSize: CGSize = .zero
    var contentView: UIView = UIView() {
        didSet {
            oldValue.removeFromSuperview()
            setupContentView()
        }
    }

    private var activeConstraints: [NSLayoutConstraint] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        initialize()
    }
}

// MARK: - Animation

extension PopupView {
    var duration: TimeInterval {
        0.2
    }

    func presentation() {
        isHidden = false
        backgroundColor = UIColor.black.withAlphaComponent(0.0)
        UIView.animate(withDuration: duration, delay: .zero, options: .curveEaseOut, animations: { [weak self] in
            self?.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        })

        contentView.transform = .init(scaleX: .zero, y: .zero)
        UIView.animate(withDuration: duration, delay: .zero, options: .curveEaseOut, animations: { [weak self] in
            self?.contentView.transform = .identity
        })
    }

    func dismiss() {
        isHidden = true
    }
}

extension PopupView {

    private func initialize() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }

    private func setupContentView() {
        addSubview(contentView)
        setupContentViewConstraints()

        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 24.0
    }

    private func setupContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.deactivate(activeConstraints)

        let constraints = [
            contentView.widthAnchor.constraint(equalToConstant: contentSize.width),
            contentView.heightAnchor.constraint(equalToConstant: contentSize.height),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        activeConstraints = constraints
    }
}

//
//  WarikanHeaderView.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/30.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift

final class WarikanHeaderView: UITableViewHeaderFooterView {

    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var divideButton: UIButton! // swiftlint:disable:this private_outlet

    private(set) var disposeBag = DisposeBag()

    var text: String? {
        didSet {
            titleLabel.text = text
        }
    }

    var color: UIColor? {
        get {
            return backView.backgroundColor
        }
        set {
            backView.backgroundColor = newValue
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }
}

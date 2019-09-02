//
//  SummeryView.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

@IBDesignable
class SummeryView: UIView {

    private static let height: CGFloat = 136

    @IBOutlet private weak var moneyLabel: UILabel!
    @IBOutlet private weak var kashikariLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNib()
    }

    func loadNib() {
        addViewWithFilling(R.nib.summeryView(owner: self))
    }

    func set(_ money: Int) {
        let type = DebtType.make(money: money)
        moneyLabel.text = String.convertWithComma(from: abs(money))
        kashikariLabel.text = type.rawValue + "ています"
    }
}

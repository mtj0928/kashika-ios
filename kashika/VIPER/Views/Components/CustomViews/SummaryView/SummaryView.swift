//
//  SummaryView.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

@IBDesignable
class SummaryView: UIView {

    private static let height: CGFloat = 136

    @IBOutlet private weak var sumLabel: UILabel!
    @IBOutlet private weak var noMoneyView: UIView!
    @IBOutlet private weak var moneyLabel: UILabel!
    @IBOutlet private weak var unitLabel: UILabel!
    @IBOutlet private weak var kashikariLabel: UILabel!

    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var bottomImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNib()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        loadNib()
    }

    func loadNib() {
        addViewWithFilling(R.nib.summaryView(owner: self))
    }

    func set(_ money: Int) {
        let type = DebtType.make(money: money)
        moneyLabel.text = String.convertWithComma(from: abs(money))
        switch type {
        case .none:
            setupCardForGray()
        case .kari:
            setupCardForRed()
        case .kashi:
            setupCardForBlue()
        }
    }

    private func setupCardForBlue() {
        sumLabel.text = "合計"
        unitLabel.isHidden = false
        kashikariLabel.text = "貸しています"
        topImageView.image = R.image.blue_top()
        bottomImageView.image = R.image.blue_bottom()
        backgroundColor = UIColor.app.blueCardColor
        noMoneyView.isHidden = true
        moneyLabel.isHidden = false
        unitLabel.isHidden = false
    }

    private func setupCardForRed() {
        sumLabel.text = "合計"
        unitLabel.isHidden = false
        kashikariLabel.text = "借りています"
        topImageView.image = R.image.red_top()
        bottomImageView.image = R.image.red_bottom()
        backgroundColor = UIColor.app.redCardColor
        noMoneyView.isHidden = true
        moneyLabel.isHidden = false
        unitLabel.isHidden = false
    }

    private func setupCardForGray() {
        sumLabel.text = " "
        unitLabel.isHidden = true
        kashikariLabel.text = " "
        topImageView.image = R.image.gray_top()
        bottomImageView.image = R.image.gray_bottom()
        backgroundColor = UIColor.app.grayCardColor
        noMoneyView.isHidden = false
        moneyLabel.isHidden = true
        unitLabel.isHidden = true
    }
}

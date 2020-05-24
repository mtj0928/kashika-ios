//
//  CalculatorInputView.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/20.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import TapticEngine

class CalculatorInputView: UIButton {

    @IBOutlet private weak var devideButton: CalculatorButton!
    @IBOutlet private weak var multipleButton: CalculatorButton!
    @IBOutlet private weak var subButton: CalculatorButton!
    @IBOutlet private weak var plusButton: CalculatorButton!
    @IBOutlet private weak var pointButton: CalculatorButton!
    @IBOutlet private weak var deleteButton: CalculatorButton!

    weak var keyInput: UIKeyInput?

    var canBeInsertSymbol: Bool = false {
        didSet {
            symbolButtons.forEach { $0.isEnabled = canBeInsertSymbol }
        }
    }
    private var symbolButtons: [UIButton] {
        return [
            devideButton,
            multipleButton,
            subButton,
            plusButton,
            pointButton
        ]
    }

    init(frame: CGRect, keyInput: UIKeyInput? = nil) {
        self.keyInput = keyInput
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

    private func loadNib() {
        addViewWithFilling(R.nib.calculatorInputView(owner: self))
        TapticEngine.impact.prepare(.light)

        deleteButton.imageView?.contentMode = .scaleAspectFit
        deleteButton.contentVerticalAlignment = .fill
        deleteButton.contentHorizontalAlignment = .fill
    }

    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else {
            return
        }

        TapticEngine.impact.feedback(.light)
        keyInput?.insertText(buttonText)
    }

    @IBAction func tappedDeleteButton(_ sender: Any) {
        TapticEngine.impact.feedback(.light)
        keyInput?.deleteBackward()
    }
}

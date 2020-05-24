//
//  DeleteButton.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/24.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

final class DeleteButton: CalculatorButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupAttributes()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupAttributes()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        setupAttributes()
    }

    private func setupAttributes() {
        // set up UI
        imageView?.image = R.image.delete_button()
        imageView?.contentMode = .scaleAspectFit
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
    }
}

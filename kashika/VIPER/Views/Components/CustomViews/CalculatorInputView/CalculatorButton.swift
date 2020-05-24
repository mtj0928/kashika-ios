//
//  CalculatorButton.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/20.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

@IBDesignable
class CalculatorButton: HighlightButton {

    private var originalColor: UIColor?
    
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
        setTitleColor(UIColor.app.placeHolderText, for: .disabled)
        originalColor = backgroundColor
    }
}

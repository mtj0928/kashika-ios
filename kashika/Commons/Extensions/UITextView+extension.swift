//
//  UITextView+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/03.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

extension UITextView: UITextViewDelegate {

    var placeholderLabel: UILabel? {
        return viewWithTag(100) as? UILabel
    }

    var placeholder: String? {
        get {
            var placeholderText: String?
            if let placeHolderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeHolderLabel.text
            }
            return placeholderText
        }
        set {
            let placeHolderLabel = self.viewWithTag(100) as? UILabel
            if placeHolderLabel == nil {
                addPlaceholderLabel(placeholderText: newValue ?? "")
            } else {
                placeHolderLabel?.text = newValue
                placeHolderLabel?.sizeToFit()
            }
            update()
        }
    }

    public func textViewDidChange(_ textView: UITextView) {
        let placeHolderLabel = viewWithTag(100)
        placeHolderLabel?.isHidden = hasText
    }

    private func update() {
        let placeHolderLabel = viewWithTag(100)
        placeHolderLabel?.isHidden = !text.isEmpty
    }

    private func addPlaceholderLabel(placeholderText: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin.x = 5.0
        placeholderLabel.frame.origin.y = 5.0
        placeholderLabel.font = font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100

        addSubview(placeholderLabel)
        delegate = self
    }

    func setDoneButton() {
        let toolBar: UIToolbar = UIToolbar()
        toolBar.barStyle = .default

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(self.closeKeyboard))
        let toolBarItems = [spacer, doneButton]
        toolBar.setItems(toolBarItems, animated: false)
        toolBar.sizeToFit()
        
        self.inputAccessoryView = toolBar
    }

    @objc
    private func closeKeyboard() {
        resignFirstResponder()
    }
}

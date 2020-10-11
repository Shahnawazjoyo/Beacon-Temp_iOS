//
//  UITextField.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    /// Add done button on keyboard
    func addDoneButtonOnKeyboard() {
        // toolbar style
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        // done button
        let doneButton   = UIButton()
        doneButton.setTitle("DONE".localized, for: .normal)
        doneButton.setTitleColor(AppColors.grayDark, for: .normal)
        doneButton.setTitleColor(AppColors.blueLight, for: .highlighted)
        doneButton.setTitleColor(AppColors.blueLight, for: .selected)
        doneButton.titleLabel?.font = AppFonts.bigBold
        doneButton.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        doneButton.addTarget(self, action: #selector(self.self.doneButtonAction), for: .touchUpInside)
        // set toolbar button item
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(customView: doneButton)
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    /// Done button action
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    /// Customize text field with app style
    func appStyle() {
        self.font = AppFonts.small
        self.backgroundColor = AppColors.white
        self.textColor = AppColors.black
        self.layer.masksToBounds = true
    }

    func appStyleItalic() {
        self.font = AppFonts.smallItalic
        self.backgroundColor = AppColors.grayLight
        self.textColor = AppColors.black
        self.layer.masksToBounds = true
    }
    
    /**
     Customize text field with app style with custom padding - color - font
     - parameter padding: the padding number
     - parameter color: the border color
     - parameter font: the text font
     - parameter bgColor: the text field background color
     */
    func appStyle(padding: Int, color: UIColor, font: UIFont, bgColor:UIColor = UIColor.clear) {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let border = CALayer()
        let height = CGFloat(0.5)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - height, width:  screenWidth - 2 * CGFloat(padding), height: height)
        border.borderWidth = height
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.backgroundColor = bgColor
        self.font = font
        self.textAlignment = .left
    }
    
    /**
     Set the left padding for text field
     - parameter number: the padding number
     */
    func setLeftPaddingPoints(_ number: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: number, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    /**
     Set the right padding for text field
     - parameter number: the padding number
     */
    func setRightPaddingPoints(_ number: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: number, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    /**
     Set text field as error style
     - parameter text: the text for field
     */
    func isError(text: String) {
        if !text.isEmpty {
            self.text = text
        }
        self.textColor = AppColors.red
        self.layer.borderColor = AppColors.red.cgColor
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.isSecureTextEntry = false
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 20, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 20, y: self.center.y))
        self.layer.add(shake, forKey: "position")
    }
    
    /**
     Set text field as normal style
     - parameter text: the text for field
     */
    func isNormal(text: String) {
        if !text.isEmpty {
            self.text = text
        }
        self.textColor = AppColors.black
        self.layer.borderWidth = 0
    }
}

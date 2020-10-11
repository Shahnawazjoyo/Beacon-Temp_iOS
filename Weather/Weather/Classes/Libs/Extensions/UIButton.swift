//
//  UIButton.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    /// Customize button style with background and text colors
    func appStyle(title: String, font: UIFont, textColor: UIColor = AppColors.white, bgColor: UIColor = UIColor.clear, borderColor: UIColor = UIColor.clear, borderWidth: CGFloat = 1, cornerRadius: CGFloat = 0, icon: UIImage = UIImage(), iconURL: String = String(), isReversedColors: Bool = false) {
        if bgColor != .clear {
            self.layer.cornerRadius = 6
        }
        if cornerRadius > 0 {
            self.layer.cornerRadius = cornerRadius
        }
        self.layer.borderColor = borderColor.cgColor
        if borderColor != .clear {
            self.layer.borderWidth = borderWidth
        }
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
        setTitle(title, for: .normal)
        setTitle(title, for: .highlighted)
        setTitle(title, for: .selected)
        titleLabel?.font = font
        setTitleColor(textColor, for: .normal)
        setTitleColor(textColor, for: .highlighted)
        setTitleColor(textColor, for: .selected)
        // change background color alpha
        if bgColor != .clear {
            setBackgroundImage(UIImage(color: bgColor), for: .normal)
            setBackgroundImage(UIImage(color: bgColor.withAlphaComponent(0.7)), for: .highlighted)
            setBackgroundImage(UIImage(color: bgColor.withAlphaComponent(0.7)), for: .selected)
            setBackgroundImage(UIImage(color: bgColor.withAlphaComponent(0.7)), for: .disabled)
        } else {// change text color alpha
            setTitleColor(textColor, for: .normal)
            setTitleColor(textColor.withAlphaComponent(0.7), for: .highlighted)
            setTitleColor(textColor.withAlphaComponent(0.7), for: .selected)
            setTitleColor(textColor.withAlphaComponent(0.7), for: .disabled)
        }
        // reversed highlight colors
        if isReversedColors {
            setTitleColor(bgColor, for: .highlighted)
            setTitleColor(bgColor, for: .selected)
            setBackgroundImage(UIImage(color: textColor), for: .highlighted)
            setBackgroundImage(UIImage(color: textColor), for: .selected)
        }
    }
    
    /// Align the image and title verticallt in the button
    func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
        
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }
    
}

//
//  UILabel.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    /// Customize label style with background and text colors
    func appStyle(text: String, font: UIFont, textColor: UIColor = AppColors.white, bgColor: UIColor = UIColor.clear) {
        if bgColor != .clear {
            self.layer.cornerRadius = self.frame.height / 2
            self.layer.masksToBounds = true
        }
        self.text = text
        self.font = font
        self.textColor = textColor
        self.backgroundColor = bgColor
    }

}

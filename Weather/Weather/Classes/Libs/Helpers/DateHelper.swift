//
//  DateHelper.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 14/06/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import Foundation
import UIKit

// MARK: Date helper
struct DateHelper {
    
    /**
     Get date object from iso string
     - parameter format: the date formate
     - parameter milliseconds: date in milliseconds
     - returns: the date String
     */
    /// Date string from date.
    static func string(withFormat format: String, milliseconds: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = AppConfig.timeZone
        dateFormatter.dateFormat = format
        let ti = TimeInterval(milliseconds)
        let date = Date(timeIntervalSince1970: ti)
        return dateFormatter.string(from: date)
    }
}

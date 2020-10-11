//
//  Constants.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import UIKit


// MARK: Application configuration

struct AppConfig {
    // environemt
    static var environment: AppEnvironment {
        return .dev
    }

    // Coordinates
    static let defaultCoordinate: Coordinate = Coordinate(id: "", lat: 24.466667, long: 54.366669)
    
    // Weather API Key
    static let weatherApiKey = "88a3340ebdff6603e38e021e9d5f20fb"
    // Time Zone
    static let timeZone = TimeZone(abbreviation: "GST")

    /// Set navigation bar style, text and color
    static func setNavigationStyle() {
        // set text title attributes
        let attrs = [NSAttributedString.Key.foregroundColor : AppColors.white,
                     NSAttributedString.Key.font : AppFonts.normalBold]
        UINavigationBar.appearance().titleTextAttributes = attrs
        // set background color
        UINavigationBar.appearance().barTintColor = AppColors.skyBlue
    }
}

// MARK: Screen size
enum ScreenSize {
    static let isSmallScreen =  UIScreen.main.bounds.height <= 568 // iphone 4/5
    static let isMidScreen =  UIScreen.main.bounds.height <= 667 // iPhone 6 & 7
    static let isBigScreen =  UIScreen.main.bounds.height >= 736 // iphone 6Plus/7Plus
    static let isXBigScreen =  UIScreen.main.bounds.height >= 812 // iphone X
    static let isIphone = UIDevice.current.userInterfaceIdiom == .phone
    static let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}

// MARK: App environment
enum AppEnvironment {
    case dev
    
    /// Application Base URL
    var appBaseURL: String {
        return "http://api.openweathermap.org"
    }
    
    /// Application URL Version
    var appURLVersion: String {
        return "/data/2.5"
    }
}


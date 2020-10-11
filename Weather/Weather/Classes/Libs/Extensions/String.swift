//
//  String.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import UIKit

extension String {
    
    /// return index of sub string
    func indexOf(target: String) -> Int? {
        let range = (self as NSString).range(of: target)
        guard Range(range) != nil else {
            return nil
        }
        return range.location
    }
    /// last Index Of sub string
    func lastIndexOf(target: String) -> Int? {
        let range = (self as NSString).range(of: target, options: NSString.CompareOptions.backwards)
        guard Range(range) != nil else {
            return nil
        }
        return self.count - range.location - 1
    }
    
    /// check if sub string exist
    func contains(s: String) -> Bool {
        return (self.range(of: s) != nil) ? true : false
    }
    
    /// Check if string contains one or more emojis.
    public var containEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x3030, 0x00AE, 0x00A9, // Special Characters
            0x1D000...0x1F77F, // Emoticons
            0x2100...0x27BF, // Misc symbols and Dingbats
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// Convert Arabic digits to English
    public var replacedArabicDigitsWithEnglish: String {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    
    /// Get the width for string
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    /// An array of all words in a string
    public func words() -> [String] {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
    
    /// Check if the string is a valid email
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    /// Check if the string is alphanumeric
    var isAlphanumeric: Bool {
        return self.range(of: "^[a-z A-Z]+$", options:String.CompareOptions.regularExpression) != nil
    }
    
    var isNumber: Bool {
        return self.range(of: "^[0-9]+$", options:String.CompareOptions.regularExpression) != nil
    }
    
    /// Localized current string key
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Localized text using string key
    public static func localized(_ key:String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    /// Remove spaces and new lines
    var trimed :String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Get label height for string
    func getLabelHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let label = UILabel(frame: .zero)
        label.frame.size.width = width
        label.font = font
        label.numberOfLines = 0
        label.text = self
        label.sizeToFit()
        return label.frame.size.height
    }
    
    /// Validates if a String is a URL
    func isValidURL() -> Bool {
        // -- requires http/https
        if let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    /// Encode URL
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    
    /// Decode URL
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
    
    /// Get random string
    public static func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    /// seperate a string without deleting the seperator in the returned array
    public func separate(withChar char : String) -> [String]{
        var word : String = ""
        var words : [String] = [String]()
        for character in self {
            if String(character) == char && word != "" {
                words.append(word)
                word = char
            }else {
                word += String(character)
            }
        }
        words.append(word)
        return words
    }
    
    static func timeToString(time: Int) -> String {
        let sec = Int(time % 60)
        let min = Int((time / 60) % 60)
        let hrs = Int(time / 3600)
        let str = String.localizedStringWithFormat(NSLocalizedString("%02d:%02d:%02d", comment: ""), hrs, min, sec)
        return str
    }
    
    static func trafficToString(bytes: UInt64) -> String {
        if bytes < 1024 {
            // b
            return String.localizedStringWithFormat(NSLocalizedString("%4dB", comment: ""), bytes)
        } else if bytes < 1024 * 1024 {
            // Kb
            return String.localizedStringWithFormat(NSLocalizedString("%3.1fKB", comment: ""), Double(bytes) / 1024)
        } else if bytes < 1024 * 1024 * 1024 {
            // Mb
            return String.localizedStringWithFormat(NSLocalizedString("%3.1fMB", comment: ""), Double(bytes) / (1024 * 1024))
        } else {
            // Gb
            return String.localizedStringWithFormat(NSLocalizedString("%3.1fGB", comment: ""), Double(bytes) / (1024 * 1024 * 1024))
        }
    }
    
    static func bandwidthToString(bps: Double) -> String {
        if bps < 1000 {
            // b
            return String.localizedStringWithFormat(NSLocalizedString("%4dbps", comment: ""), Int(bps))
        } else if bps < 1000 * 1000 {
            // Kb
            return String.localizedStringWithFormat(NSLocalizedString("%3.1fKbps", comment: ""), bps / 1000)
        } else if bps < 1000 * 1000 * 1000 {
            // Mb
            return String.localizedStringWithFormat(NSLocalizedString("%3.1fMbps", comment: ""), bps / (1000 * 1000))
        } else {
            // Gb
            return String.localizedStringWithFormat(NSLocalizedString("%3.1fGbps", comment: ""), bps / (1000 * 1000 * 1000))
        }
    }
}


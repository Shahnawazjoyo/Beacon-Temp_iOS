//
//  MKScanBeaconModel.swift
//  Weather
//
//  Created by Neuron Dubai on 11/10/2020.
//  Copyright © 2020 Muhammad Nadeem. All rights reserved.
//

import Foundation
import MKBeaconXProSDK


class MKScanBeaconModel {
    private var indexKey = ("indexKey" as NSString).utf8String
    var infoBeacon:MKBXPDeviceInfoBeacon?
    var identifier: String?
    var rssi: NSNumber?
    var index:Int?
    var dataArray:[MKBXPBaseBeacon]?
    var deviceName: String?
    var displayTime:String?
    var lastScanDate:String?
    
    
    func setIndex(_ index: Int) {
        objc_setAssociatedObject(self, &indexKey, NSNumber(value: index), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func getIndex() -> Int {
        return (objc_getAssociatedObject(self, &indexKey) as? NSNumber)?.intValue ?? 0
    }
}

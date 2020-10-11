//
//  WeatherBeaconTests.swift
//  WeatherBeaconTests
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import Foundation
import XCTest
@testable import WeatherBeacon

class WeatherBeaconTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// Test WeatherBeacon Model and View Model
    func testWeatherBeaconModel() {
        
        let WeatherBeaconElement = WeatherBeaconElement(id: "1", WeatherBeaconDescription: "clear sky", mainDescription: "Clear")
        let main = Main(id: "1", temp: 38.25, tempMin: 3.87, tempMax: 38.25)
        
        let wind = Wind(id: "1", speed: 4.8)
        
        let WeatherBeacon = WeatherBeacon(id: "1", cityName: "Abu Dhabi", dateInt: 1592071200, WeatherBeaconElement: WeatherBeaconElement, main: main, wind: wind)
                
        let WeatherBeaconViewModel = WeatherBeaconViewModel(WeatherBeacon: WeatherBeacon)

        XCTAssertEqual(WeatherBeacon.cityName, WeatherBeaconViewModel.cityName)
        XCTAssertEqual(WeatherBeacon.dateInt, WeatherBeaconViewModel.dateInt)
        XCTAssertEqual(WeatherBeacon.WeatherBeaconElement?.WeatherBeaconDescription, WeatherBeaconViewModel.WeatherBeaconElementViewModel.WeatherBeaconDescription)
        XCTAssertEqual(WeatherBeacon.WeatherBeaconElement?.mainDescription, WeatherBeaconViewModel.WeatherBeaconElementViewModel.mainDescription)

        XCTAssertEqual(WeatherBeacon.main?.temp, WeatherBeaconViewModel.mainViewModel.temp)
        XCTAssertEqual(WeatherBeacon.main?.tempMin, WeatherBeaconViewModel.mainViewModel.tempMin)
        XCTAssertEqual(WeatherBeacon.main?.tempMax, WeatherBeaconViewModel.mainViewModel.tempMax)
        XCTAssertEqual(WeatherBeacon.wind?.speed, WeatherBeaconViewModel.windViewModel.speed)

    }
    
}

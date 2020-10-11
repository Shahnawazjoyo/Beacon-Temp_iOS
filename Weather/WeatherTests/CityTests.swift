//
//  CityTests.swift
//  WeatherBeaconTests
//
//  Created by Shah Nawaz on 14/06/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import Foundation
import XCTest
@testable import WeatherBeacon

class CityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// Test WeatherBeacon Model and View Model
    func testWeatherBeaconModel() {
        let city = City(id: "1", name: "Abu Dhabi")
        let cityViewModel = CityViewModel(city: city)
        XCTAssertEqual(city.name, cityViewModel.name)
    }
    
}

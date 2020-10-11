//
//  XCTestCase.swift
//  WeatherBeaconUITests
//
//  Created by Shah Nawaz on 14/06/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import XCTest

extension XCTestCase {

    /// Go to Home View
    func waitForHomeView(_ app: XCUIApplication) {
        addUIInterruptionMonitor(withDescription: "Send Notifications Alert") { (alert) -> Bool in
            alert.buttons["Allow"].tap()
            return true
        }
        
        // wait to laod navigation items
        let homeView = app.otherElements["homeView"]
        let exists = NSPredicate(format: "exists == 1")
        let exp = expectation(for: exists, evaluatedWith: homeView, handler: nil)
        let result = XCTWaiter.wait(for: [exp], timeout: 10)
        if result == XCTWaiter.Result.timedOut {
            if !homeView.exists {
                print("Go To Home View Failure")
                app.terminate()
                return
            }
        }
    }
 
    /// Terminate app
    func terminateApp (_ app: XCUIApplication, _ msg: String){
        print(msg)
        XCTAssert(true)
        app.terminate()
        return
    }
}

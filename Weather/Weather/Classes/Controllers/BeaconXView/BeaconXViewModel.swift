//
//  HomeViewModel.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconxViewModel {
    
    // MARK: Data
    public var weathersList: [WeatherViewModel] = DataStore.shared.weathersList.map{WeatherViewModel(weather: $0)}
    var refreshData: Bool = false

    // MARK: Functions
    
    /**
     Get current weather by city name
     - parameter completionBlock: closure to return back the success or failure result
     - parameter success: the process finished successfully
     - parameter error: error back from server
     */
    func getWeatherBy(cityNames: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        // get current weather by city name
        let names = cityNames.components(separatedBy: ",")
        for name in names {
            let cityName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            ApiManager.shared.getCurrentWeatherBy(cityName: cityName) { [self] (success, error, weather) in
                if success {
                    if let weatherObj = weather {
                        let weatherViewModel = WeatherViewModel(weather: weatherObj)
                       
                        if self.refreshData {
                            self.refreshData = false
                            DataStore.shared.weathersList = []
                            DataStore.shared.weathersList.append(weatherObj)
                            self.weathersList.append(weatherViewModel)
                        }
                        if(weathersList.count>0){
                            DataStore.shared.weathersList[0] = weatherObj
                            self.weathersList[0] = weatherViewModel
                        }
                        
                        DataStore.shared.weathersList.append(weatherObj)
                    }
                    completionBlock(true, nil)
                }else {
                    completionBlock(false, error)
                }
            }
        }

    }
    
    /// CLGeocoder for getting the city name through coordinates
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        let local = Locale(identifier: "en_US")
        if #available(iOS 11.0, *) {
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude), preferredLocale: local) { completion($0?.first, $1) }
        } else {
            // Fallback on earlier versions
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
        }
    }
}

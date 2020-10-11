//
//  CityViewModel.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 14/06/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import Foundation

// MARK: City view model class
class CityViewModel: BaseViewModel {
    
    // MARK: Properties
    public var name: String

    /**
     Dependency Injection (DI)
     - parameter name: the city object
     - returns: An initalized instance of the class.
     */
    public init(city: City) {
        self.name = city.name ?? ""
        super.init(id: city.id)
    }
    
    /**
     Convert the object back to city
     - returns: An initalized instance of city
     */
    public func convertToCity() -> City {
        return City(id: id, name: name)
    }
}

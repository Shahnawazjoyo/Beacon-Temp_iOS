//
//  WeatherBeaconViewModel.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import Foundation

class WeatherViewModel: BaseViewModel {

    // MARK: Properties
    public var cityName: String
    public var dateInt: Int
    public var weatherElementViewModel: WeatherElementViewModel
    public var mainViewModel: MainViewModel
    public var windViewModel: WindViewModel
    
    /**
     Dependency Injection (DI)
     - parameter weather: the weather object
     - returns: An initalized instance of the class.
     */
    public init(weather: Weather) {
        self.cityName = weather.cityName ?? "-"
        self.dateInt = weather.dateInt ?? 0
        self.weatherElementViewModel = WeatherElementViewModel(weatherElement: weather.weatherElement ?? WeatherElement())
        self.mainViewModel = MainViewModel(main: weather.main ?? Main())
        self.windViewModel = WindViewModel(wind: weather.wind ?? Wind())
        super.init(id: weather.id)
    }
    
    /**
     Convert the object back to weather
     - returns: An initalized instance of weather
     */
    public func convertToWeather() -> Weather {
        let weatherElement = self.weatherElementViewModel.convertToWeatherElement()
        let main = self.mainViewModel.convertToMain()
        let wind = self.windViewModel.convertToWind()
        return Weather(id: id, cityName: cityName, dateInt: dateInt, weatherElement: weatherElement, main: main, wind: wind)
    }
}

// MARK: Weather Element view model class
class WeatherElementViewModel: BaseViewModel {
    
    // MARK: Properties
    public var weatherDescription: String
    public var mainDescription: String

    /**
     Dependency Injection (DI)
     - parameter weatherElement: the weather element object
     - returns: An initalized instance of the class.
     */
    public init(weatherElement: WeatherElement) {
        self.weatherDescription = weatherElement.weatherDescription ?? ""
        self.mainDescription = weatherElement.mainDescription ?? ""
        super.init(id: weatherElement.id)
    }
    
    /**
     Convert the object back to weather element
     - returns: An initalized instance of weather element
     */
    public func convertToWeatherElement() -> WeatherElement {
        return WeatherElement(id: id, weatherDescription: weatherDescription, mainDescription: mainDescription)
    }
}

// MARK: Main view model class
class MainViewModel: BaseViewModel {
    
    // MARK: Properties
    public var temp: Double
    public var tempMin: Double
    public var tempMax: Double

    /**
     Dependency Injection (DI)
     - parameter main: the main object of values
     - returns: An initalized instance of the class.
     */
    public init(main: Main) {
        self.temp = main.temp ?? 0.0
        self.tempMin = main.tempMin ?? 0.0
        self.tempMax = main.tempMax ?? 0.0
        super.init(id: main.id)
    }
    
    /**
     Convert the object back to main
     - returns: An initalized instance of main
     */
    public func convertToMain() -> Main {
        return Main(id: id, temp: temp, tempMin: tempMin, tempMax: tempMax)
    }
}

// MARK: Wind view model class
class WindViewModel: BaseViewModel {
    
    // MARK: Properties
    public var speed: Double

    /**
     Dependency Injection (DI)
     - parameter wind: the wind object
     - returns: An initalized instance of the class.
     */
    public init(wind: Wind) {
        self.speed = wind.speed ?? 0.0
        super.init(id: wind.id)
    }
    
    /**
     Convert the object back to wind
     - returns: An initalized instance of wind
     */
    public func convertToWind() -> Wind {
        return Wind(id: id, speed: speed)
    }
}

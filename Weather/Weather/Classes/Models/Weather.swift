//
//  WeatherBeacon.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import SwiftyJSON

class Weather: BaseModel {
    // MARK: Keys
    private let kCityNameKey = "name"
    private let kDateKey = "dt"
    private let kWeatherArrayKey = "weather"
    private let kMainKey = "main"
    private let kWindKey = "wind"
    // MARK: Properties
    public var cityName: String?
    public var dateInt: Int?
    public var weatherElement: WeatherElement?
    public var main: Main?
    public var wind: Wind?
        
    // MARK: initializer
    public override init(){
        super.init()
    }
    
    /**
     Dependency Injection (DI)
     - parameter id: the id
     - parameter cityName: the name of the city
     - parameter dateInt: the date of the forecast
     - parameter weatherElement: the element of the weather
     - parameter main: main values of the weather
     - parameter wind: the wind
     - returns: An initalized instance of the class.
     */
    public init(id: String = "", cityName: String, dateInt: Int, weatherElement: WeatherElement, main: Main, wind: Wind) {
        super.init(id: id)
        self.cityName = cityName
        self.dateInt = dateInt
        self.weatherElement = weatherElement
        self.main = main
        self.wind = wind
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public required init(json: JSON) {
        super.init(json: json)
        cityName = json[kCityNameKey].string
        dateInt =  json[kDateKey].int
        if let weatherElementsArr = json[kWeatherArrayKey].array, weatherElementsArr.count > 0 {
            weatherElement = WeatherElement(json: weatherElementsArr[0])
            
        }
        if (json[kMainKey] != JSON.null) {
            main = Main(json: json[kMainKey])
        }
        if (json[kWindKey] != JSON.null) {
            wind = Wind(json: json[kWindKey])
        }
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public override func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        // cityName
        if let value = cityName {
            dictionary[kCityNameKey] = value
        }
        // dateInt
        if let value = dateInt {
            dictionary[kDateKey] = value
        }
        // weatherElements
        if let value: WeatherElement = weatherElement {
            dictionary[kWeatherArrayKey] = value.dictionaryRepresentation()
        }
        // main values
        if let value = main {
            dictionary[kMainKey] = value.dictionaryRepresentation()
        }
        // wind
        if let value = wind {
            dictionary[kWindKey] = value.dictionaryRepresentation()
        }
        return dictionary
    }
}

// MARK: - WeatherElement
class WeatherElement: BaseModel {
    // MARK: Keys
    private let kDescriptionKey = "description"
    private let kMainDescriptionKey = "main"

    // MARK: Properties
    public var weatherDescription: String?
    public var mainDescription: String?
    
    // MARK: initializer
    public override init(){
        super.init()
    }
    
    /**
     Dependency Injection (DI)
     - parameter id: the id of the weather element
     - parameter weatherDescription: the description of the weather
     - parameter mainDescription: the main description of the weather
     - returns: An initalized instance of the class.
     */
    public init(id: String = "", weatherDescription: String, mainDescription: String) {
        super.init(id: id)
        self.weatherDescription = weatherDescription
        self.mainDescription = mainDescription
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public required init(json: JSON) {
        super.init(json: json)
        weatherDescription = json[kDescriptionKey].string
        mainDescription = json[kMainDescriptionKey].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public override func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        // weatherDescription
        if let value = weatherDescription {
            dictionary[kDescriptionKey] = value
        }
        // mainDescription
        if let value = mainDescription {
            dictionary[kMainDescriptionKey] = value
        }
        return dictionary
    }
}

// MARK: - Main
class Main: BaseModel {
    // MARK: Keys
    private let kTempKey = "temp"
    private let kTempMinKey = "temp_min"
    private let kTempMaxKey = "temp_max"
    // MARK: Properties
    public var temp: Double?
    public var tempMin: Double?
    public var tempMax: Double?
    
    // MARK: initializer
    public override init(){
        super.init()
    }
    
    /**
     Dependency Injection (DI)
     - parameter temp: the current temperator of the weather
     - parameter tempMin: the minimum temperator
     - parameter tempMax: the maximum temperator
     - returns: An initalized instance of the class.
     */
    public init(id: String = "", temp: Double, tempMin: Double, tempMax: Double) {
        super.init(id: id)
        self.temp = temp
        self.tempMin = tempMin
        self.tempMax = tempMax
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public required init(json: JSON) {
        super.init(json: json)
        temp = json[kTempKey].double
        tempMin = json[kTempMinKey].double
        tempMax = json[kTempMaxKey].double
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public override func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        // temp
        if let value = temp {
            dictionary[kTempKey] = value
        }
        // tempMin
        if let value = tempMin {
            dictionary[kTempMinKey] = value
        }
        // tempMax
        if let value = tempMax {
            dictionary[kTempMaxKey] = value
        }
        return dictionary
    }
}

// MARK: - Wind
class Wind: BaseModel {
    // MARK: Keys
    private let kSpeedKey = "speed"
    // MARK: Properties
    public var speed: Double?
    
    // MARK: initializer
    public override init(){
        super.init()
    }
    
    /**
     Dependency Injection (DI)
     - parameter speed: the speed of the wind
     - returns: An initalized instance of the class.
     */
    public init(id: String = "", speed: Double) {
        super.init(id: id)
        self.speed = speed
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public required init(json: JSON) {
        super.init(json: json)
        speed = json[kSpeedKey].double
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public override func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        // speed
        if let value = speed {
            dictionary[kSpeedKey] = value
        }
        return dictionary
    }
}

//
//  Coordinate.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import SwiftyJSON

class Coordinate: BaseModel {
    // MARK: Keys
    private let kLatKey = "lat"
    private let kLongKey = "long"
    // MARK: Properties
    public var lat: Double?
    public var long: Double?
    
    // MARK: initializer
    public override init(){
        super.init()
    }
    
    /**
     Dependency Injection (DI)
     - parameter id: the id of the coordinate
     - parameter lat: the latitude of the coordinate
     - parameter long: the longitude of the coordinate
     - returns: An initalized instance of the class.
     */
    public init(id: String = "", lat: Double, long: Double) {
        super.init(id: id)
        self.lat = lat
        self.long = long
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public required init(json: JSON) {
        super.init(json: json)
        lat = json[kLatKey].double ?? 0.0
        long = json[kLongKey].double ?? 0.0
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public override func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        // latitude & longitude
        dictionary[kLatKey] = lat
        dictionary[kLongKey] = long
        return dictionary
    }
}

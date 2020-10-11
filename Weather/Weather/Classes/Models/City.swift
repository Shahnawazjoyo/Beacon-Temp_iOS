//
//  City.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 14/06/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import SwiftyJSON

class City: BaseModel {
    // MARK: Keys
    private let kNameKey = "name"

    // MARK: Properties
    public var name: String?
    
    // MARK: initializer
    public override init(){
        super.init()
    }
    
    /**
     Dependency Injection (DI)
     - parameter id: the id of the city
     - parameter name: the name of the city
     - returns: An initalized instance of the class.
     */
    public init(id: String = "", name: String) {
        super.init(id: id)
        self.name = name
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public required init(json: JSON) {
        super.init(json: json)
        name = json[kNameKey].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public override func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        // WeatherBeaconDescription
        if let value = name {
            dictionary[kNameKey] = value
        }
        return dictionary
    }
}

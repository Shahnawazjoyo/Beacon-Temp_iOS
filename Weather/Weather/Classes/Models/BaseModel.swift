//
//  BaseModel.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import SwiftyJSON

/**
 a base model for all business objects in the app, offers comon members and methods among all models
 */
public class BaseModel: NSObject {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kBaseModelIdKey: String = "id"

    // MARK: Properties
    
    public var id: String = ""
    
    override init() {
    }
    
    // Dependency Injection (DI)
    /**
     Initates the instance based on id
     - parameter id: The object id
     - returns: An initalized instance of the class.
     */
    public init(id: String) {
        self.id = id
    }
    
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the instance based on the object
     - parameter object: The object of either Dictionary or Array kind that was passed.
     - returns: An initalized instance of the class.
     */
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public required init(json: JSON) {
        id = json[kBaseModelIdKey].stringValue
    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[kBaseModelIdKey] = id
        return dictionary
    }
    
    /**
     Check if a BaseModel is equal another one
     - parameter item: the BaseModel item
     - returns: true/false for equal models
     */
    func isEqual<T:BaseModel>(item:T) -> Bool {
        if item.id == self.id {
            return true
        }
        return false
    }
    
    // MARK: arrays utils
    /**
     Check if a BaseModel is exist in the array
     - parameter arr: the BaseModel array
     - returns: true/false for existing in
     */
    func isExistIn<T:BaseModel>(arr:[T]?) -> Bool {
        guard let array = arr else {
            return false
        }
        if array.contains(where: { $0.id == self.id }) {
            return true
        } else {
            return false
        }
    }
    
    /**
     Find the BaseModel object by ID inside array
     - parameter arr: the BaseModel array
     - parameter id: the BaseModel id
     - returns: BaseModel object
     */
    func findObjectById<T:BaseModel>(arr:[T] , id: String) -> T? {
        let object = arr.filter{$0.id == id}.first
        return object
    }
    
    /**
     Remove the BaseModel object by ID from array
     - parameter arr: the BaseModel array
     - parameter id: the BaseModel id
     - returns: BaseModel array
     */
    func removeObjectById<T:BaseModel>(arr:[T] , id: String) -> [T] {
        var result = arr
        if let index = arr.firstIndex(where: {$0.id == id}) {
            result.remove(at: index)
        }
        return result
    }
}

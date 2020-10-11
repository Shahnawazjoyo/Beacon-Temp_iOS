//
//  BaseViewModel.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import SwiftyJSON

/**
 a base view model for all business objects in the app, offers comon members and methods among all models
 */
public class BaseViewModel {

    // MARK: Properties
    public var id: String = ""
    
    // Dependency Injection (DI)
    /**
     Initates the instance based on id
     - parameter id: The object id
     - returns: An initalized instance of the class.
     */
    init(id: String) {
        self.id = id
    }
    
    /**
     Check if a BaseViewModel is equal another one
     - parameter item: the BaseViewModel item
     - returns: true/false for equal models
     */
    func isEqual<T:BaseViewModel>(item:T) -> Bool {
        if item.id == self.id {
            return true
        }
        return false
    }
    
    // MARK: arrays utils
    /**
     Check if a BaseViewModel is exist in the array
     - parameter arr: the BaseViewModel array
     - returns: true/false for existing in
     */
    func isExistIn<T:BaseViewModel>(arr:[T]?) -> Bool {
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
     Find the BaseViewModel object by ID inside array
     - parameter arr: the BaseViewModel array
     - parameter id: the BaseViewModel id
     - returns: BaseViewModel object
     */
    func findObjectById<T:BaseViewModel>(arr:[T] , id: String) -> T? {
        let object = arr.filter{$0.id == id}.first
        return object
    }
    
    /**
     Remove the BaseViewModel object by ID from array
     - parameter arr: the BaseViewModel array
     - parameter id: the BaseViewModel id
     - returns: BaseViewModel array
     */
    func removeObjectById<T:BaseViewModel>(arr:[T] , id: String) -> [T] {
        var result = arr
        if let index = arr.firstIndex(where: {$0.id == id}) {
            result.remove(at: index)
        }
        return result
    }
    
    /**
     Get the BaseViewModel object index by ID from array
     - parameter arr: the BaseViewModel array
     - parameter id: the BaseViewModel id
     - returns: BaseViewModel array
     */
    func indexObjectById<T:BaseViewModel>(arr:[T]) -> Int {
        if let index = arr.firstIndex(where: {$0.id == self.id}) {
            return index
        }
        return -1
    }
}

//
//  DataStore.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import SwiftyJSON

/** This class handle all data needed by view controllers and other app classes
 
 It deals with:
 - Userdefault for read/write cached data
 - Any other data sources e.g social provider, contacts manager, etc..
 ** Usage:**
 - to write something to cache; add a constant key and a computed property accessors (set,get) and use the according method  (save,load)
 */
class DataStore :NSObject {
    
    // MARK: Cache keys
    private let CACHE_KEY_WEATHERS_LIST = "weatherList"
    
    // MARK: Temp data holders
    // keep reference to the written value in another private property just to prevent reading from cache each time you use this var
    private var _weathersList: [Weather] = []
    
    // MARK: Cached data

    /// Local saved list of weathers
    public var weathersList: [Weather] {
        set {
            _weathersList = newValue
            saveBaseModelArray(array: _weathersList, withKey: CACHE_KEY_WEATHERS_LIST)
        }
        get {
            if (_weathersList.isEmpty) {
                _weathersList = loadBaseModelArrayForKey(key: CACHE_KEY_WEATHERS_LIST)
            }
            return _weathersList
        }
    }
        
    // MARK: Singelton
    public static var shared: DataStore = DataStore()
    
    private override init(){
        super.init()
    }
    
    // MARK: Cache Utils
    public func saveBaseModelArray(array: [BaseModel] , withKey key:String){
        let data : [[String:Any]] = array.map{$0.dictionaryRepresentation()}
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    /// Load base model array from key
    public func loadBaseModelArrayForKey<T:BaseModel>(key: String)->[T]{
        var result : [T] = []
        if let arr = UserDefaults.standard.array(forKey: key) as? [[String: Any]]
        {
            result = arr.map{T(json: JSON($0))}
        }
        return result
    }
    
    /// Save base model object with key
    public func saveBaseModelObject<T:BaseModel>(object:T?, withKey key:String)
    {
        UserDefaults.standard.set(object?.dictionaryRepresentation(), forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    /// Load base model object for key
    public func loadBaseModelObjectForKey<T:BaseModel>(key:String) -> T?
    {
        if let object = UserDefaults.standard.object(forKey: key) {
            return T(json: JSON(object))
        }
        return nil
    }
    
    /// Load string for key
    public func loadStringForKey(key:String) -> String {
        let storedString = UserDefaults.standard.object(forKey: key) as? String ?? ""
        return storedString;
    }
    
    /// Save string with key
    public func saveStringWithKey(stringToStore: String, key: String) {
        UserDefaults.standard.set(stringToStore, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    /// Save string with key
    public func removeStringWithKey(key: String) {
        UserDefaults.standard.removeObject(forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    /// Load int for key
    private func loadIntForKey(key:String) -> Int {
        let storedInt = UserDefaults.standard.object(forKey: key) as? Int ?? 0
        return storedInt;
    }
    
    /// Save int with key
    private func saveIntWithKey(intToStore: Int, key: String) {
        UserDefaults.standard.set(intToStore, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    /// Load bool for key
    private func loadBoolForKey(key: String) -> Bool {
        let storedBool = UserDefaults.standard.object(forKey: key) as? Bool ?? false
        return storedBool
    }
    
    /// Save bool with key
    private func saveBoolWithKey(boolToStore: Bool, key: String){
        UserDefaults.standard.set(boolToStore, forKey: key);
        UserDefaults.standard.synchronize()
    }
    
    /// Load object for key
    private func loadObjectForKey(key:String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    /// Save object with key
    private func saveObjectWithKey(object: Any, key: String){
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize();
    }
    
    /// Clear cache
    public func clearCache() {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }
}

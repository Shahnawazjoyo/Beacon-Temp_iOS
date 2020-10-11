//
//  ApiManager.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import SwiftyJSON
import Alamofire

/// - Api store do all Networking stuff
///     - build server request
///     - prepare params
///     - and add requests headers
///     - parse Json response to App data models
///     - parse error code to Server error object
///
class ApiManager: NSObject {
    
    /// frequent request headers
    var headers: HTTPHeaders{
        get {
            let contentType = HTTPHeader(name: "Content-Type", value: "application/json")
            let httpHeadersArray = [contentType]
            let httpHeaders = HTTPHeaders(httpHeadersArray)
            return httpHeaders
        }
    }
    
    // MARK: Data
    let baseURL = "\(AppConfig.environment.appBaseURL)/\(AppConfig.environment.appURLVersion)/"
    let error_domain = "Test"
    
    // MARK: Shared Instance
    static let shared: ApiManager = ApiManager()
    
    private override init(){
        super.init()
    }
    
    /**
    make api request and return request
     - parameter url: request url
     - parameter method: http method of request eg: get, post
     - parameter parameters: body parameters
     - parameter completionHandler: closure to return back the success or failure result
     - parameter responseObject: any data response
     - parameter jsonResponse: JSON response object
     - parameter error: error back from server
     */
    func makeRequest(url: String, method: HTTPMethod, parameters: [String: Any]?, completionHandler: @escaping (_ responseObject: AFDataResponse<Any>, _ jsonResponse: JSON?, _ error: ServerError?) -> Void) -> DataRequest {

        let request = AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) in

            if let error = self.parseResponse(responseObject: responseObject) {
                completionHandler(responseObject, nil, error)
            }else {
                switch responseObject.result {
                case .success(let value): // success case
                    let jsonResponse = JSON(value)
                    completionHandler(responseObject, jsonResponse, nil)
                case .failure(_): // failure case
                    let error = self.parseResponse(responseObject: responseObject)
                    completionHandler(responseObject, nil, error)
                }
            }
        }
        return request
    }
    
    /**
     Parse the response object to return any server error
     - parameter responseObject: any data response
     - returns: error back from server or nothing
     */
    private func parseResponse(responseObject: AFDataResponse<Any>) -> ServerError? {
        switch responseObject.result {
        case .success(let value):
            let jsonResponse = JSON(value)
            if let code = responseObject.response?.statusCode, code >= 400 {
                let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                return serverError
            }
        case .failure:
            if let code = responseObject.response?.statusCode, code >= 400 {
                return ServerError.unknownError
            } else {
                return ServerError.connectionError
            }
        }
        return nil
    }
    
    // MARK: Authorization
    /**
     Get current weather by city name
     - parameter cityName: the name of city
     - parameter completionBlock: closure to return back the success or failure result
     - parameter success: the process finished successfully
     - parameter error: error back from server
     */
    func getCurrentWeatherBy(cityName: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ weather: Weather?) -> Void) {
        // url & parameters
        let orignalURL = "\(baseURL)weather?q=\(cityName)&APPID=\(AppConfig.weatherApiKey)&units=metric"
        let requestURL = orignalURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""

        _ = makeRequest(url: requestURL, method: .get, parameters: nil) { (responseObject, jsonResponse, serverError) in
            if let error = serverError {
                completionBlock(false, error, nil)
            } else {// success case
                guard let jsonResponse = jsonResponse else { return }
                // parse response
                let weather = Weather(json: jsonResponse)
                completionBlock(true, nil, weather)
            }
        }
    }
    
    
}

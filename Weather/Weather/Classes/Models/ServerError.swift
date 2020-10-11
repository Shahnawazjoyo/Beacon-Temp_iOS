//
//  ServerError.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import SwiftyJSON

/**
 Server error represents custome errors types from back end
 */
struct ServerError {

    public var errorName: String?
    public var status: Int?
    public var code: Int!

    public var type: ErrorType {
        get {
            return ErrorType(rawValue: code) ?? .unknown
        }
    }

    /// Server errors codes meaning according to backend
    enum ErrorType: Int {

        // in app errors
        case connection = -100
        case unknown = -101
        // server errors
        case versionTooOld = 102
        
        /// Handle generic error messages
        var errorMessage: String {
            switch (self) {
            case .connection:
                return "ERROR_NO_CONNECTION".localized
            case .unknown:
                return "ERROR_UNKNOWN".localized
            // server errors
            case .versionTooOld:
                return "OLD_VERSION_MESSAGE".localized
            }
        }
    }

    /// Connection error
    public static var connectionError: ServerError {
        get {
            var error = ServerError()
            error.code = ErrorType.connection.rawValue
            return error
        }
    }

    /// Unknow error
    public static var unknownError: ServerError {
        get {
            var error = ServerError()
            error.code = ErrorType.unknown.rawValue
            return error
        }
    }

    // MARK: initializer
    public init() {
    }

    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public init?(json: JSON) {
        guard let errorCode = json["cod"].string else {
            return nil
        }
        code = Int(errorCode)
        if let errorString = json["message"].string{ errorName = errorString}
        if let statusCode = json["status"].int{ status = statusCode}
    }
}

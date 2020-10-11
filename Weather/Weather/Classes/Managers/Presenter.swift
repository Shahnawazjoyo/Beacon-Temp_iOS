//
//  Presenter.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import Foundation
import UIKit

/**
 Repeated and generic actions to be excuted from any context of the app such as show alert
 */
class Presenter: NSObject {
    
    // MARK: Singelton
    public static var shared: Presenter = Presenter()
    public var cityNames: String = ""
    public var acTemp: String = ""
    private override init(){
        super.init()
    }
        
    /// Show alert screen
    public func showAlert(style: CustomAlertStyle, delegate: CustomAlertViewDelegate?, title: String = "", message: String = "", actionTitle: String = "", alertImage: UIImage? = nil, completionBlock:(@escaping()->()) = {})   {
        let alertViewController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
        alertViewController.setData(style: style, delegate: delegate, title: title, message: message, actionTitle: actionTitle, image: alertImage)
        
        alertViewController.modalPresentationStyle = .overFullScreen
        if let visibleController = UIApplication.visibleViewController() {
            if !visibleController.isBeingPresented {
                visibleController.present(alertViewController, animated: true, completion: {
                    completionBlock()
                })
            }
        }
    }
    
    /// Show winners
    public func showOtherViewController() {
        
    
    }
}

//
//  UIApplication.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication
{
    /// Key window
    static func keyWindow() -> UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    /// App window
    static func appWindow() -> UIWindow {
        if let window: UIWindow = (UIApplication.shared.delegate?.window)!{
            return window
        }
        return UIWindow()
    }
    
    /// Root view contoller
    static func rootViewController() -> UIViewController? {
        //return self.appWindow().rootViewController
        return UIApplication.keyWindow()?.rootViewController
    }

    /// Visible view controller
    static func visibleViewController(base: UIViewController? = rootViewController()) -> UIViewController?{
        //return self.rootViewController()?.findContentViewControllerRecursively()
        if let nav = base as? UINavigationController {
            return UIApplication.visibleViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return UIApplication.visibleViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return UIApplication.visibleViewController(base: presented)
        }
        return base
    }
    
    /// Visible navigation controller
    static func visibleNavigationController() -> UINavigationController? {
        return self.visibleViewController()?.navigationController
    }
    
    /// Visible tabbar controller
    static func visibleTabBarController() -> UITabBarController? {
        return self.visibleViewController()?.tabBarController
    }
    
    /// Visible split view controller
    static func visibleSplitViewController() -> UISplitViewController? {
        return self.visibleViewController()?.splitViewController
    }
    
    /// Push or present view contorller
    static func pushOrPresentViewController(viewController: UIViewController, animated:Bool) {
        if let nav:UINavigationController = self.visibleNavigationController() {
            nav.pushViewController(viewController, animated: animated)
        } else {
            self.visibleViewController()?.present(viewController, animated: animated, completion: nil)
        }
    }

}

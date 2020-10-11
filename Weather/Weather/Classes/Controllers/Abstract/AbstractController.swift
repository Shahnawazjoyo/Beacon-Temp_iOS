//
//  AbstractController.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import UIKit

class AbstractController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    /// prevents adding tap gesture to dismiss keyboard -- this is used in scenes where there aren't input fields and the tap gesture may conflicts with libs e.g. Hakawai mentions due to textViewEndEditing
    internal var dismissKeyboardTapGesture: Bool = true
    
    /// Instaniate view controller from main story board
    ///
    /// **Warning:** Make sure to set storyboard id the same as the controller class name
    class func getInstance<T:AbstractController>(from storyboard:UIStoryboard) -> T?{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? T
    }
    
    public static var className:String {
        return String(describing: self.self)
    }
    
    // MARK: Navigation Bar
    func setNavBarTitle(title : String) {
        self.navigationItem.titleView = nil
        self.navigationItem.title = title
    }
    
    func setNavBarTitle(title: String, color: UIColor) {
        let titleViewFrame = CGRect(x: 80, y: 0, width: ScreenSize.width - 160, height: 44)
        let titleLabelFrame = CGRect(x: 0, y: 0, width: titleViewFrame.width, height: titleViewFrame.height)
        let titleView = UIView(frame: titleViewFrame)
        let titleLabel = UILabel(frame: titleLabelFrame)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = AppFonts.alertBigBold
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = color
        titleView.addSubview(titleLabel)
        self.navigationItem.titleView = titleView
    }
    
    var showNavBorder:Bool = true {
        didSet {
            if let navigationController = UIApplication.visibleNavigationController() {
                navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationController.navigationBar.shadowImage = UIImage()
                if(showNavBorder) {
                    navigationController.navigationBar.setBottomBorderColor(color: AppColors.skyBlue)
                } else {
                    navigationController.navigationBar.setBottomBorderColor(color: UIColor.clear)
                }
            }
        }
    }
    
    /// Navigation bar custome back button
    var navCloseButton : UIBarButtonItem  {
        let _navBackButton   = UIButton()
        _navBackButton.setImage(UIImage(named: "navClose"), for: .normal)
        _navBackButton.setImage(UIImage(named: "navClose"), for: .highlighted)
        _navBackButton.setImage(UIImage(named: "navClose"), for: .selected)
        _navBackButton.imageView?.contentMode = .scaleAspectFit
        _navBackButton.contentHorizontalAlignment = .left
        _navBackButton.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        _navBackButton.imageEdgeInsets = UIEdgeInsets.zero
        _navBackButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: _navBackButton)
    }
    
    /// Enable back button on left side of navigation bar
    var showNavCloseButton: Bool = false {
        didSet {
            if (showNavCloseButton) {
                self.navigationItem.leftBarButtonItem = navCloseButton
            } else {
                self.navigationItem.leftBarButtonItems = nil
                self.navigationItem.leftBarButtonItems = nil
            }
        }
    }

    /// Show navigation bar loader
    func showNavLoader(dark: Bool, isViewInteractionEnabled: Bool = false) {
        let activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.startAnimating()
        if dark {
            activityIndicator.color = AppColors.blueDark
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        self.view.isUserInteractionEnabled = isViewInteractionEnabled
    }
    
    /// Hide navigation bar loader
    func hideNavLoader() {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = nil
        self.view.isUserInteractionEnabled = true
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if dismissKeyboardTapGesture {
            // hide keyboard when tapping on non input control
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        }
        
        // add navigation title logo
        self.setNavBarTitle(title: "")
        
        // hide nav border by default
        self.showNavBorder = false
        
        // customize view
        self.customizeView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // build up view
        self.buildUp()
    }
    
    /// Customize all view members (fonts - style - text)
    func customizeView() {
    }
    
    // Build up view elements
    func buildUp() {
    }
    
    @objc func backButtonAction(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true)
    }
    
    // MARK: Keyboard Hide Button
    func addDoneToolBarToKeyboard(textView:UITextView) {
        let doneToolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexibelSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let hideKeyboardButton   = UIButton()
        hideKeyboardButton.setBackgroundImage(UIImage(named: "downArrow"), for: .normal)
        hideKeyboardButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        hideKeyboardButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        let hideKeyboardItem  = UIBarButtonItem(customView: hideKeyboardButton)
        
        doneToolbar.items = [flexibelSpaceItem, hideKeyboardItem]
        doneToolbar.tintColor = UIColor.darkGray
        doneToolbar.sizeToFit()
        textView.inputAccessoryView = doneToolbar
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //MARK: UIGuesture recognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//
//  CustomAlertViewController.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import UIKit

//customAlertStyles enumeration.
enum CustomAlertStyle {
    case defaultAlert
    case oneActionAlert
    case locationAlert
    case acTempInput
}

//custom alert delegation
@objc protocol CustomAlertViewDelegate: class {
    
    //called when action finished processing.
    func customAlertSecondButtonAction()
    @objc optional func customAlertFirstButtonAction()
}

class CustomAlertViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var alertStackView: UIStackView!
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertBigImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var cityNameTextField: UITextField!
    
    // MARK: Data
    private var alertStyle: CustomAlertStyle = .defaultAlert
    private var delegate: CustomAlertViewDelegate?
    private var defaultAlertTitle = ""
    private var defaultAlertMsgText = ""
    private var defaultAlertBtnTitle = ""
    private var alertImage: UIImage?
    private var keyboardIsOpen: Bool = false
    private var cachedKeyboardHeight: CGFloat = 0.0
    var minimumCityNames: Int = 3
    var maximumCityNames: Int = 7
    var alertViewModel = CustomAlertViewModel()
    
    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.sizeToFit()
        if alertStyle == .acTempInput {
            cityNameTextField.resignFirstResponder()
        }
        customizeView()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    // Remove observer on deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func customizeView() {
        cancelButton.appStyle(title: "CANCEL".localized, font: AppFonts.small, textColor: AppColors.black)
        titleLabel.appStyle(text: "", font: AppFonts.alertBigBold, textColor: AppColors.black)
        messageLabel.appStyle(text: "", font: AppFonts.small, textColor: AppColors.grayXDark)
        dismissButton.isHidden = true
        centerButton.isHidden = true
        alertImageView.superview?.isHidden = true
        alertBigImageView.superview?.isHidden = true
        cityNameTextField.superview?.isHidden = true

        switch alertStyle {
        case .defaultAlert:
            titleLabel.text = defaultAlertTitle
            messageLabel.text = defaultAlertMsgText
            secondButton.appStyle(title: defaultAlertBtnTitle, font: AppFonts.smallBold, textColor: AppColors.blueLight, bgColor: AppColors.white, borderColor: AppColors.blueLight, cornerRadius: CGFloat(18), isReversedColors: true)
            dismissButton.isHidden = false
            break
        case .oneActionAlert:
            titleLabel.text = defaultAlertTitle
            messageLabel.text = defaultAlertMsgText
            cancelButton.isHidden = true
            secondButton.isHidden = true
            centerButton.isHidden = false
            centerButton.appStyle(title: defaultAlertBtnTitle, font: AppFonts.smallBold, textColor: AppColors.blueLight, bgColor: AppColors.white, borderColor: AppColors.blueLight, cornerRadius: CGFloat(18), isReversedColors: true)
            if alertImage != nil {
                alertImageView.image = alertImage
                alertImageView.superview?.isHidden = false
            }
            break
        case .locationAlert:
            if alertImage != nil {
                alertBigImageView.image = alertImage
                alertBigImageView.superview?.isHidden = false
            }
            stackViewTopConstraint.constant = 0
            titleLabel.appStyle(text: "", font: AppFonts.normalBold, textColor: AppColors.black)
            messageLabel.appStyle(text: "", font: AppFonts.small, textColor: AppColors.black)
            titleLabel.text = defaultAlertTitle
            messageLabel.text = defaultAlertMsgText
            cancelButton.isHidden = true
            secondButton.isHidden = true
            centerButton.isHidden = false
            centerButton.appStyle(title: defaultAlertBtnTitle, font: AppFonts.smallBold, textColor: AppColors.blueDark, bgColor: AppColors.white, borderColor: AppColors.blueDark, cornerRadius: CGFloat(18), isReversedColors: true)
            centerButton.imageView?.isHidden = true
            centerButton.setImage(nil, for: .normal)
            break
        case .acTempInput:
            titleLabel.text = "POPUP_CITY_NAME_TITLE".localized
            messageLabel.text = String(format: "POPUP_CITY_NAME_MSG".localized, minimumCityNames, maximumCityNames)
            cancelButton.isHidden = true
            cancelButton.isHidden = false
            secondButton.isHidden = false
            secondButton.isEnabled = false
            secondButton.appStyle(title: "CONTINUE".localized, font: AppFonts.smallBold, textColor: AppColors.white, bgColor: AppColors.gray, cornerRadius: CGFloat(18), isReversedColors: true)

            alertImageView.image = #imageLiteral(resourceName: "forecast")
            alertImageView.superview?.isHidden = false
            cityNameTextField.superview?.isHidden = false
            cityNameTextField.appStyle()
            cityNameTextField.keyboardType = .numberPad
            cityNameTextField.placeholder = "POPUP_CITY_NAME_PLACEHOLDER".localized
            centerButton.appStyle(title: "OK".localized, font: AppFonts.smallBold, textColor: AppColors.blueLight, bgColor: AppColors.white, borderColor: AppColors.blueLight, cornerRadius: CGFloat(18), isReversedColors: true)
            // hide keyboard when tapping on non input control
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = true
            alertStackView.addGestureRecognizer(tapGesture)
            break
            
        }
    }
    
    private func setupView() {
        alertView.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    //show view with animation
    private func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    //set view style and appearance animation.
    private func setStyle(_ style:CustomAlertStyle){
        alertStyle = style
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    }
    
    // set view data and components localized text
    func setData(style: CustomAlertStyle, delegate: CustomAlertViewDelegate?, title: String = "", message: String = "", actionTitle:String = "", image: UIImage? = nil) {
        setStyle(style)
        self.delegate = delegate
        defaultAlertTitle = title
        defaultAlertMsgText = message
        defaultAlertBtnTitle = actionTitle
        if image != nil {
            alertImage = image
        }
    }
    
    // MARK: Actions
    @IBAction func onDismissButton(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.customAlertFirstButtonAction?()
        }
    }
    
    @IBAction func onTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.customAlertFirstButtonAction?()
        }
    }
    
    @IBAction func onTapSecondButton(_ sender: Any) {
        secondButton.isEnabled = true
        self.dismiss(animated: true) {
            self.delegate?.customAlertSecondButtonAction()
        }
    }
    
    @IBAction func onTapCenterButton(_ sender: Any) {
        centerButton.isEnabled = true
        self.dismiss(animated: true) {
            self.delegate?.customAlertSecondButtonAction()
        }
    }
    
    // Tap dismiss keyboard action
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: Keyboard events
    @objc func keyboardWillShow(notification: NSNotification) {
        if !keyboardIsOpen {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if #available(iOS 11.0, *) {

                    var keyboardHeight = keyboardSize.height
                    let bottomInset = view.safeAreaInsets.bottom
                    keyboardHeight -= bottomInset

                    if cachedKeyboardHeight == 0 {
                        cachedKeyboardHeight = keyboardHeight
                    }

                    alertViewCenterYConstraint.constant -= cachedKeyboardHeight/2
                    UIView.animate(withDuration: 0.2) {
                        self.view.layoutIfNeeded()
                    }
                }
                else {
                    alertViewCenterYConstraint.constant -= keyboardSize.height/2
                }

                keyboardIsOpen = true
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if keyboardIsOpen {
            alertViewCenterYConstraint.constant += cachedKeyboardHeight/2
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }

            keyboardIsOpen = false
        }
    }
    
    // MARK: textField edit action
    @IBAction func textfieldEditedAction(_ sender: UITextField) {
        if let text = sender.text {
            if alertStyle == .acTempInput {
                //let cityNames = text.components(separatedBy: ",")
                if(text.isNumber){
                    Presenter.shared.acTemp = text
                    secondButton.isEnabled = true
                    secondButton.appStyle(title: "CONTINUE".localized, font: AppFonts.smallBold, textColor: AppColors.white, bgColor: AppColors.skyBlue, cornerRadius: CGFloat(18), isReversedColors: true)
                }else {
                    secondButton.isEnabled = false
                    secondButton.appStyle(title: "CONTINUE".localized, font: AppFonts.smallBold, textColor: AppColors.white, bgColor: AppColors.gray, cornerRadius: CGFloat(18), isReversedColors: true)

                }
                
//                if acTemp.count >= minimumCityNames && cityNames.count <= maximumCityNames {
//
//                }
            }
        }
    }
}

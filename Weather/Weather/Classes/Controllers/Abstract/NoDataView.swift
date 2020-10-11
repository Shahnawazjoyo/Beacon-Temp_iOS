//
//  NoDataView.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import Foundation
import UIKit

// no data view delegation
protocol NoDataViewDelegate: class {
    // called when quantity changed
    func actionClicked(_ noDataView: NoDataView)
}

// No data types
enum NoDataType {
    case connection
    case weatherNoLocation
    case weathersListNoData
    case weathersListNoResults

    var title: String {
        switch self {
        case .connection:
            return "NO_DATA_CONNECTION_TITLE"
        case .weatherNoLocation:
            return "NO_DATA_WEATHER_TITLE"
        case .weathersListNoData:
            return "NO_DATA_WEATHERS_LIST_TITLE"
        case .weathersListNoResults:
            return "NO_DATA_WEATHERS_RESULTS_TITLE"
        }
    }
    
    var messgae: String {
        switch self {
        case .connection:
            return "NO_DATA_CONNECTION_MESSAGE"
        case .weatherNoLocation:
            return "NO_DATA_WEATHER_MESSAGE"
        case .weathersListNoData:
            return "NO_DATA_WEATHERS_LIST_MESSAGE"
        case .weathersListNoResults:
            return "NO_DATA_WEATHERS_RESULTS_MESSAGE"
        }
    }
    
    var action: String {
        switch self {
        case .connection:
            return "NO_DATA_CONNECTION_ACTION"
        case .weatherNoLocation:
            return "NO_DATA_WEATHER_ACTION"
        case .weathersListNoData:
            return "NO_DATA_WEATHERS_LIST_ACTION"
        case .weathersListNoResults:
            return "NO_DATA_WEATHERS_RESULTS_ACTION"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .connection:
            return #imageLiteral(resourceName: "noConnection")
        case .weatherNoLocation:
            return #imageLiteral(resourceName: "noLocation")
        case .weathersListNoResults:
            return #imageLiteral(resourceName: "noLocation")
        case .weathersListNoData:
            return #imageLiteral(resourceName: "noLocation")
        }
    }
}

class NoDataView : AbstractNibView {
    // MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    
    // Constraints
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    // MARK: Data
    public var delegate: NoDataViewDelegate?
    private var type: NoDataType = .connection
    
    override func customizeView() {
        super.customizeView()
        titleLabel.font = AppFonts.normalBold
        messageLabel.font = AppFonts.small
        actionButton.appStyle(title: "", font: AppFonts.xSmallBold, textColor: AppColors.skyBlue, bgColor: AppColors.white, borderColor: AppColors.skyBlue, cornerRadius: actionButton.frame.height / 2, isReversedColors: true)
        self.layer.masksToBounds = true
    }
    
    func getViewType() -> NoDataType {
        return type
    }
    
    func updateText(type: NoDataType, noImage: Bool = false){
        self.type = type
        titleLabel.text = type.title.localized
        messageLabel.text = type.messgae.localized
        placeholderImageView.image = type.icon
        actionButton.isHidden = false
        actionButton.appStyle(title: type.action.localized, font: AppFonts.xSmallBold, textColor: AppColors.skyBlue, bgColor: AppColors.white, borderColor: AppColors.skyBlue, cornerRadius: CGFloat(12), isReversedColors: true)
        
        if noImage {
            placeholderImageView.isHidden = true
            imageHeightConstraint.constant = 0
        }
    }
    
    func setMessage(title: String, message: String, icon: UIImage, action: String = ""){
        titleLabel.text = title
        messageLabel.text = message
        placeholderImageView.image = icon
        actionButton.appStyle(title: action, font: AppFonts.xSmallBold, textColor: AppColors.skyBlue, bgColor: AppColors.white, borderColor: AppColors.skyBlue, cornerRadius: actionButton.frame.height / 2, isReversedColors: true)
        actionButton.isHidden = false
        if action.isEmpty {
            actionButton.isHidden = true
        }
    }
    
    /// Show skeleton loading animaiton
    func showLoadingAnimation(isDark: Bool = false) {
        DispatchQueue.main.async {
            if isDark {
                let gradient = SkeletonGradient(baseColor: AppColors.blueLight)
                self.placeholderImageView.showAnimatedGradientSkeleton(usingGradient: gradient)
                self.titleLabel.showAnimatedGradientSkeleton(usingGradient: gradient)
                self.messageLabel.showAnimatedGradientSkeleton(usingGradient: gradient)
                self.actionButton.showAnimatedGradientSkeleton(usingGradient: gradient)
                self.actionButton.borderColor = UIColor.clear
            }
            else {
                let gradient = SkeletonGradient(baseColor: UIColor.clouds)
                self.placeholderImageView.showAnimatedGradientSkeleton(usingGradient: gradient)
                self.titleLabel.showAnimatedGradientSkeleton(usingGradient: gradient)
                self.messageLabel.showAnimatedGradientSkeleton(usingGradient: gradient)
                self.actionButton.showAnimatedGradientSkeleton(usingGradient: gradient)
                self.actionButton.borderColor = UIColor.clear
            }
        }
        
    }
    
    /// Hide skeleton loading animaiton
    func hideLoadingAnimation() {
        DispatchQueue.main.async {
            self.placeholderImageView.hideSkeleton()
            self.titleLabel.hideSkeleton()
            self.messageLabel.hideSkeleton()
            self.actionButton.hideSkeleton()
            self.actionButton.borderColor = AppColors.skyBlue
        }
    }
    
    func stopLoadingAnimation() {
        DispatchQueue.main.async {
            self.placeholderImageView.stopSkeletonAnimation()
            self.titleLabel.stopSkeletonAnimation()
            self.messageLabel.stopSkeletonAnimation()
            self.actionButton.stopSkeletonAnimation()
        }
    }
    
    // MARK: Actions
    /// No data action
    @IBAction func noDataAction(_ sender: UIButton) {
        delegate?.actionClicked(self)
    }
}

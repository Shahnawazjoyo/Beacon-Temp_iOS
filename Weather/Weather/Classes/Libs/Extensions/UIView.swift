//
//  UIView.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import UIKit

class ClosureSleeve {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

enum AnimationType {
    case animateIn
    case animateInFromBottom
    case animateInFromRight
    case animateInFromLeft
    case animateOut
    case animateOutToBottom
    case animateOutToRight
    case animateOutToLeft
}

extension UIView {
    
    /// Mark: properties
    public static let animDurationLong = 0.8
    public static let animDurationShort = 0.4
    private static let animDist: CGFloat = 20.0
    
    /// add **touch up selector** to any **view**
    ///
    /// Usage:
    ///
    ///     view.tapAction{print("View tapped!")}
    ///
    /// - Parameters:
    ///     - closure: The block to be excuted when tapping.
    func tapAction( _ closure: @escaping ()->()){
        self.isUserInteractionEnabled = true
        let sleeve = ClosureSleeve(closure)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    /// Pop in animation
    func popIn(fromScale: CGFloat = 0.5,
               duration: TimeInterval = 0.5,
               delay: TimeInterval = 0.0,
               completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.isHidden = false
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: fromScale, y: fromScale)
        UIView.animate(
            withDuration: duration, delay: delay, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
        }, completion: completion)
        return
    }
    
    /// Fade the current view in
    func fadeIn(duration: TimeInterval = 0.5,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { self.alpha = 1.0 },
                       completion: completion)
        return
    }
    
    /// Fade the current view out
    func fadeOut(duration: TimeInterval = 0.5,
                 delay: TimeInterval = 0.0,
                 completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { self.alpha = 0.0 },
                       completion: completion)
        return
    }
    
    /// Fade the current view in and set isHidden flag to false before fading in
    func fadeInWithHidden(duration: TimeInterval = 0.5,
                          delay: TimeInterval = 0.0) {
        self.alpha = 0
        self.isHidden = false
        self.fadeIn(duration: duration, delay: delay)
    }
    
    /// Fade the current view out and set isHidden flag to true when finished fading
    func fadeOutWithHidden(duration: TimeInterval = 0.5,
                           delay: TimeInterval = 0.0) {
        self.fadeOut(duration: duration, delay: delay, completion: {(finished) in self.isHidden = true })
    }
    
    /// Add shadows
    func addShadow(offsetX: CGFloat, offsetY: CGFloat, shadowOpacity: Float, shadowRadius: CGFloat) {
        // actions view
        self.layer.masksToBounds = false
        self.layer.shadowColor = AppColors.black.cgColor
        self.layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
    }
    
    /// set corner radius from interface builder
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    /// set border width from interface builder
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    /// set border color from interface builder
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
    }
    
    /// add top border with color
    func addTopBorderWithColor(color: UIColor, height: CGFloat) {
        let border = CALayer()
        border.name = "borderLayer"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: height)
        self.layer.addSublayer(border)
    }
    
    /// add right border with color
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "borderLayer"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    /// add bottom border with color
    func addBottomBorderWithColor(color: UIColor, height: CGFloat) {
        let border = CALayer()
        border.name = "borderLayer"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - height, width: self.frame.size.width, height: height)
        self.layer.addSublayer(border)
    }
    
    /// add left border with color
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "borderLayer"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    /// remove all borders
    func removeAllBorders() {
        if let subLayers = self.layer.sublayers {
            for layer in subLayers {
                if layer.name == "borderLayer" {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    /// make view rounded
    func asCircle(){
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
    }

    //MARK: animation
    func shake(delegate: CAAnimationDelegate) {
        let animationKeyPath = "transform.translation.x"
        let shakeAnimation = "shake"
        let duration = 0.6
        let animation = CAKeyframeAnimation(keyPath: animationKeyPath)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        animation.delegate = delegate
        layer.add(animation, forKey: shakeAnimation)
    }
    
    func animateIn(mode: AnimationType, delay: CFTimeInterval) {
        var initialTransform: CGAffineTransform = CGAffineTransform.identity
        var finalTransform: CGAffineTransform = CGAffineTransform.identity
        let initialAlpha: CGFloat
        let finalAlpha: CGFloat
        
        switch mode {
        case .animateIn:
            initialTransform = CGAffineTransform.identity
        case .animateInFromBottom:
            initialTransform = CGAffineTransform(translationX: 0, y: UIView.animDist)
        case .animateInFromRight:
            initialTransform = CGAffineTransform(translationX: UIView.animDist, y: 0)
        case .animateInFromLeft:
            initialTransform = CGAffineTransform(translationX: -UIView.animDist, y: 0)
        case .animateOut:
            finalTransform = CGAffineTransform.identity
        case .animateOutToBottom:
            finalTransform = CGAffineTransform(translationX: 0, y: UIView.animDist)
        case .animateOutToRight:
            finalTransform = CGAffineTransform(translationX: UIView.animDist, y: 0)
        case .animateOutToLeft:
            finalTransform = CGAffineTransform(translationX: -UIView.animDist, y: 0)
        }
        
        switch mode {
        case .animateIn,
             .animateInFromLeft,
             .animateInFromRight,
             .animateInFromBottom:
            finalTransform = CGAffineTransform.identity
            initialAlpha = 0
            finalAlpha = 1
        case .animateOut,
             .animateOutToLeft,
             .animateOutToRight,
             .animateOutToBottom:
            initialTransform = CGAffineTransform.identity
            initialAlpha = 1
            finalAlpha = 0
        }
        
        self.alpha = initialAlpha
        self.transform = initialTransform
        UIView.animate(withDuration: 1, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.alpha = finalAlpha
            self.transform = finalTransform
        }) { _ in
            
        }
    }
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _ = _round(corners: corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
}

private extension UIView {
    
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        
        removeBorderLayer()
        
        let borderLayer = CAShapeLayer()
        borderLayer.name = "borderLayer"
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        layer.addSublayer(borderLayer)
    }
    
    func removeBorderLayer(){
        if let sublayers = layer.sublayers{
            for subLayer in sublayers {
                if(subLayer.name == "borderLayer"){
                    subLayer.removeFromSuperlayer()
                }
            }
        }
    }
}

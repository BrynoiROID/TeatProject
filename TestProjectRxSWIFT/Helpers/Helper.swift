//
//  Helper.swift
//  TestProjectRxSWIFT
//
//  Created by iROID on 05/03/21.
//

import Foundation

import UIKit

class Helper{
//MARK:- App Using Urls
static var App_Base_Url : String = "http://imaginato.mocklab.io/"
//MARK:- App Using Strings
static var AppName : String = "RxSWIFT"
//MARK:- App Using Colour Codes
static var AppPrimaryColor : String = "#FF3C41"
static var AppStatusBarColor : String = "#FF5258"
static var AppIndicatorColor : String = "#FF5258"
//MARK:- App Using Attributes Properties
static var AppViewCornerRadius : CGFloat = 20.0
static var AppButtonCornerRadius : CGFloat = 10.0
static var AppButtonBorderWidth : CGFloat = 1.0
//MARK:- MessageBox
static func showAlert(message: String) {
   let alert = UIAlertController(title: Helper.AppName, message: message as String, preferredStyle: UIAlertController.Style.alert)
   alert.view.tintColor = Helper.colorFromHexString(hex: Helper.AppPrimaryColor)
   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
   alert.view.tintColor = Helper.colorFromHexString(hex: Helper.AppPrimaryColor)
   UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
 }

//MARK:- Colour code change From hex to string
   static func colorFromHexString (hex:String) -> UIColor {
   var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
   if (cString.hasPrefix("#")) {
           cString.remove(at: cString.startIndex)
               }
               if ((cString.count) != 6) {
                   return UIColor.gray
               }
               var rgbValue:UInt64 = 0
               Scanner(string: cString).scanHexInt64(&rgbValue)
               return UIColor(
                   red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                   green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                   blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                   alpha: CGFloat(1.0)
               )
   }

//MARK:- StatusBar Colour
static func StatusBarColor(view:UIView){
        if #available(iOS 13.0, *) {
           let app = UIApplication.shared
           let statusBarHeight: CGFloat = app.statusBarFrame.size.height
           let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.clear
           view.addSubview(statusbarView)
               
           statusbarView.translatesAutoresizingMaskIntoConstraints = false
           statusbarView.heightAnchor
               .constraint(equalToConstant: statusBarHeight).isActive = true
           statusbarView.widthAnchor
               .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
           statusbarView.topAnchor
               .constraint(equalTo: view.topAnchor).isActive = true
           statusbarView.centerXAnchor
               .constraint(equalTo: view.centerXAnchor).isActive = true

               
               
           } else {
              
               let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = self.colorFromHexString(hex: self.AppStatusBarColor)
                 
        }
}

// MARK: - Email Validation Function
static func validateEmail(_ candidate: String) -> Bool {
    
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
}

//MARK:- InterNet Checking
static func checkConnectivity() -> Bool {
    do {
        let reachability = try Reachability()
        if reachability.connection != .unavailable {
                return true
        } else {
                return false
        }
    }catch let err {
                   print(err)
        }
       return false
}
}

extension String {
func isValidPassword() -> Bool {
    let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d$@$!%*?&]{8,}"
    let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)

    return passwordValidation.evaluate(with: self)
}

}

// MARK: - Indicator Class
open class JTMaterialSpinner: UIView {

public let circleLayer = CAShapeLayer()
open private(set) var isAnimating = false
open var animationDuration : TimeInterval = 2.0

override public init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
}

required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
}

open func commonInit() {
    self.layer.addSublayer(circleLayer)
    circleLayer.fillColor = nil
    circleLayer.lineCap = CAShapeLayerLineCap.round
    circleLayer.lineWidth = 1.5
    circleLayer.strokeColor = UIColor.black.cgColor
    circleLayer.strokeStart = 0
    circleLayer.strokeEnd = 0
}

open override func layoutSubviews() {
    super.layoutSubviews()
    
    if self.circleLayer.frame != self.bounds {
        updateCircleLayer()
    }
}

open func updateCircleLayer() {
    let center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
    let radius = (self.bounds.height - self.circleLayer.lineWidth) / 2.0
    let startAngle : CGFloat = 0.0
    let endAngle : CGFloat = 2.0 * CGFloat.pi
    let path = UIBezierPath(arcCenter: center,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: true)
    self.circleLayer.path = path.cgPath
    self.circleLayer.frame = self.bounds
}

open func forceBeginRefreshing() {
    self.isAnimating = false
    self.beginRefreshing()
}

open func beginRefreshing() {
    
    if(self.isAnimating){
        return
    }
    
    self.isAnimating = true
    
    let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
    rotateAnimation.values = [
        0.0,
        Float.pi,
        (2.0 * Float.pi)
    ]
    
    
    let headAnimation = CABasicAnimation(keyPath: "strokeStart")
    headAnimation.duration = (self.animationDuration / 2.0)
    headAnimation.fromValue = 0
    headAnimation.toValue = 0.25
    
    let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
    tailAnimation.duration = (self.animationDuration / 2.0)
    tailAnimation.fromValue = 0
    tailAnimation.toValue = 1
    
    let endHeadAnimation = CABasicAnimation(keyPath: "strokeStart")
    endHeadAnimation.beginTime = (self.animationDuration / 2.0)
    endHeadAnimation.duration = (self.animationDuration / 2.0)
    endHeadAnimation.fromValue = 0.25
    endHeadAnimation.toValue = 1
    
    
    let endTailAnimation = CABasicAnimation(keyPath: "strokeEnd")
    endTailAnimation.beginTime = (self.animationDuration / 2.0)
    endTailAnimation.duration = (self.animationDuration / 2.0)
    endTailAnimation.fromValue = 1
    endTailAnimation.toValue = 1
    
    let animations = CAAnimationGroup()
    animations.duration = self.animationDuration
    animations.animations = [
        rotateAnimation,
        headAnimation,
        tailAnimation,
        endHeadAnimation,
        endTailAnimation
    ]
    animations.repeatCount = Float.infinity
    animations.isRemovedOnCompletion = false

    self.circleLayer.add(animations, forKey: "animations")
}

open func endRefreshing () {
    self.isAnimating = false
    self.circleLayer.removeAnimation(forKey: "animations")
}

}

class LoadingIndicatorView {

static var currentOverlay : UIView?
static var currentOverlayTarget : UIView?
static var currentLoadingText: String?

static let spinnerView = JTMaterialSpinner()

static func show() {
    guard let currentMainWindow = UIApplication.shared.keyWindow else {
        print("No main window.")
        return
    }
    show(currentMainWindow)
}

static func show(_ loadingText: String) {
    guard let currentMainWindow = UIApplication.shared.keyWindow else {
        print("No main window.")
        return
    }
    show(currentMainWindow, loadingText: loadingText)
}

static func show(_ overlayTarget : UIView) {
    show(overlayTarget, loadingText: nil)
}

static func show(_ overlayTarget : UIView, loadingText: String?) {
    // Clear it first in case it was already shown
    hide()
    
 
    
    // Create the overlay
    let overlay = UIView(frame: overlayTarget.frame)
    overlay.center = overlayTarget.center
    overlay.backgroundColor = UIColor.clear
    overlayTarget.addSubview(overlay)
    overlayTarget.bringSubviewToFront(overlay)
    

    
    
    overlay.addSubview(spinnerView)
    spinnerView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    spinnerView.center = overlay.center
        
    spinnerView.circleLayer.lineWidth = 2.0
    spinnerView.circleLayer.strokeColor = Helper.colorFromHexString(hex: Helper.AppIndicatorColor).cgColor
    spinnerView.beginRefreshing()

    
    currentOverlay = overlay
    currentOverlayTarget = overlayTarget
    currentLoadingText = loadingText
    
}

static func hide() {
    if currentOverlay != nil {
        spinnerView.endRefreshing()
        currentOverlay?.removeFromSuperview()
        currentOverlay =  nil
        currentLoadingText = nil
        currentOverlayTarget = nil
    }
}

@objc private static func rotated() {
    // handle device orientation change by reactivating the loading indicator
    if currentOverlay != nil {
        show(currentOverlayTarget!, loadingText: currentLoadingText)
    }
}
}

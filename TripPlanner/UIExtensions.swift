//
//  UIExtensions.swift
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit


/**
 * Extensions for UIColor
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
extension UIColor {
    
    /**
     Creates new color with RGBA values from 0-255 for RGB and a from 0-1
     
     - parameter r: the red color
     - parameter g: the green color
     - parameter b: the blue color
     - parameter a: the alpha color
     */
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
    
    /**
     Get UIColor from hex string, e.g. "FF0000" -> red color
     
     - parameter hexString: the hex string
     
     - returns: the UIColor instance or nil
     */
    class func fromString(hexString: String) -> UIColor? {
        if hexString.characters.count == 6 {
            let redStr = hexString.substringToIndex(hexString.startIndex.advancedBy(2))
            let greenStr = hexString.substringWithRange(Range<String.Index>(
                start: hexString.startIndex.advancedBy(2),
                end: hexString.startIndex.advancedBy(4)))
            let blueStr = hexString.substringFromIndex(hexString.startIndex.advancedBy(4))
            return UIColor(
                r: CGFloat(Int(redStr, radix: 16)!),
                g: CGFloat(Int(greenStr, radix: 16)!),
                b: CGFloat(Int(blueStr, radix: 16)!))
        }
        return nil
    }
    
    /**
     light gray color
     */
    class func lightGray() -> UIColor {
        return UIColor.fromString("A4ACB0")!
    }
    
    /**
     very light gray color
     */
    class func veryLightGray() -> UIColor {
        return UIColor.fromString("FAFCFE")!
    }
    
}



/**
 * Extension for UIViewController
 * Helpful functions to manage controllers
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
extension UIViewController {
    
    /**
     Load child controller inside contentView
     
     - parameter vc: child controller
     - parameter contentView: container view
     */
    func loadChildController(vc: UIViewController, inContentView contentView: UIView) {
        self.addChildViewController(vc)
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vc.view)
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|",
            options: [], metrics: nil, views: ["view" : vc.view]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|",
            options: [], metrics: nil, views: ["view" : vc.view]))
        
        self.view.layoutIfNeeded()

        vc.didMoveToParentViewController(self)
    }
    
    /**
     Unload child controller from its parent
     
     - parameter vc: child controller
     */
    func unloadChildController(vc: UIViewController?) {
        if let vc = vc {
            vc.willMoveToParentViewController(nil)
            vc.removeFromParentViewController()
            vc.view.removeFromSuperview()
        }
    }
    
    /**
     Show alert
     
     - parameter title: the title of the alert
     - parameter message: the message of the alert
     */
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: handler))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
     Show error alert
     
     - parameter message: the message of the error alert
     */
    func showErrorAlert(message: String) {
        self.showAlert(NSLocalizedString("Error", comment: ""), message: message)
    }
    
    /**
     Create a view controller from storyboard.
     By default will load from the same storyboard of self storyboard.
     
     - parameter controllerClass: type of controller
     - parameter storyboardName: the name of storyboard
     
     - returns: the controller instance from storyboard
     */
    func create<T: UIViewController>(controllerClass: T.Type, storyboardName: String? = nil) -> T? {
        let className = String.stringFromClass(controllerClass)
        var storyboard = self.storyboard
        if let storyboardName = storyboardName {
            storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        }
        let controller = storyboard?.instantiateViewControllerWithIdentifier(className) as? T
        return controller
    }
    
    /**
     wraps view controller in a navigation controller
     
     - returns: parent navigation controller
     */
    func wrapInNavigationController() -> UINavigationController {
        let navigation = UINavigationController(rootViewController: self)
        navigation.navigationBar.translucent = false
        return navigation
    }
}

/**
 * Extensions for UIFont
 * Helpful functions to create UIFont
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
extension UIFont {
    /**
     bold Poppins font
     
     - parameter size: font size
     */
    class func boldPoppinsFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: size)!
    }
    
    /**
     bold Poppins font
     
     - parameter size: font size
     */
    class func lightPoppinsFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Light", size: size)!
    }
    
    /**
     regular Poppins font
     
     - parameter size: font size
     */
    class func poppinsFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: size)!
    }
    
}

/**
 * Shortcut methods for UITableView
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
extension UITableView {
    
    /**
     Get cell of given class for indexPath
     
     - parameter indexPath: the indexPath
     - parameter cellClass: a cell class
     
     - returns: a reusable cell
     */
    func getCell<T: UITableViewCell>(indexPath: NSIndexPath, ofClass cellClass: T.Type) -> T {
        let className = String.stringFromClass(cellClass)
        return self.dequeueReusableCellWithIdentifier(className, forIndexPath: indexPath) as! T
    }
}

/**
 * Placeholder color & unwrapped text
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
extension UITextField {
    
    /// placeholder color
    var placeholderColor: UIColor {
        get {
            return self.valueForKeyPath("_placeholderLabel.textColor") as! UIColor
        }
        set {
            self.setValue(newValue, forKeyPath: "_placeholderLabel.textColor")
        }
    }
    
    /// unwrapped text value
    var textValue: String {
        return text ?? ""
    }
    
}

/**
 * Shake effect support on a view
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
extension UIView {
    
    /**
     Shake the view as rejection action.
     */
    func shake(callback: (()->())? = nil) {
        shake(5, callback: callback)
    }
    
    /**
     Shake the view
     
     - parameter shakes:   the number of shakes
     - parameter callback: callback to invoke at the end
     */
    private func shake(shakes: Int, callback: (()->())? = nil) {
        if shakes == 0 {
            self.transform = CGAffineTransformIdentity
            callback?()
            return
        }
        
        UIView.animateWithDuration(0.05, animations: { () -> Void in
            self.transform = CGAffineTransformMakeTranslation(shakes % 2 == 0 ? 8 : -8, 0)
            }) { (_) -> Void in
                self.shake(shakes - 1, callback: callback)
        }
    }
}

/**
 * First responder helper
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
extension UIView {
    /**
     Finds the first responder
     
     - returns: the first responder, or nil if nothing found.
     */
    func findFirstResponder() -> UIView? {
        if isFirstResponder() { return self }
        else {
            for view in subviews {
                if let responder = view.findFirstResponder() {
                    return responder
                }
            }
            return nil
        }
    }
}

/// iPad check
let IS_IPAD = UIDevice.currentDevice().userInterfaceIdiom == .Pad
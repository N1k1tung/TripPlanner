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
     dark blue color
     */
    class func darkBlueColor() -> UIColor {
        return UIColor(r: 0, g: 31, b: 59)
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
     Load child controller :vc inside :contentView
     
     - parameters:
     - vc: child controller
     - contentView: container view
     */
    func loadChildController(vc: UIViewController, inContentView contentView: UIView) {
        self.addChildViewController(vc)
        contentView.addSubview(vc.view)
        vc.view.frame.size = contentView.frame.size
        vc.didMoveToParentViewController(self)
    }
    
    /**
     Unload child controller :vc from its parent
     
     - parameters:
     - vc: child controller
     */
    func unloadChildController(vc: UIViewController?) {
        if let vc = vc {
            vc.willMoveToParentViewController(nil)
            vc.view.removeFromSuperview()
            vc.removeFromParentViewController()
        }
    }
    
    /**
     Show alert
     
     - parameters:
     - title: the title of the alert
     - message: the message of the alert
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
        self.showAlert("Error", message: message)
    }
    
    /**
     Create a view controller from storyboard.
     By default will load from the same storyboard of self storyboard.
     
     - parameters:
     - controllerClass: type of controller
     - storyboardName: the name of storyboard
     
     - returns: the controller instance from storyboard
     */
    func create<T: UIViewController>(controllerClass: T.Type, storyboardName: String? = nil) -> T? {
        let className = NSStringFromClass(controllerClass).componentsSeparatedByString(".").last!
        var storyboard = self.storyboard
        if let storyboardName = storyboardName {
            storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        }
        let controller = storyboard?.instantiateViewControllerWithIdentifier(className) as? T
        return controller
    }
    
    /**
     Class function to create a view controller from Main storyboard.
     
     - parameters:
     - controllerClass: type of the controller
     
     - returns: the controller instance from storyboard
     */
    class func createFromMainStoryboard<T: UIViewController>(controllerClass: T.Type) -> T? {
        let className = NSStringFromClass(controllerClass).componentsSeparatedByString(".").last!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(className) as? T
        return controller
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
     bold Arial font
     
     - parameter size: font size
     */
    class func boldArialFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Arial-BoldMT", size: size)!
    }
    
    /**
     regular Arial font
     
     - parameter size: font size
     */
    class func arialFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Arial", size: size)!
    }
    
}

/**
 * Extension for UIImage
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
extension UIImage {
    
    /**
     adds a text on top of self
     
     - parameter text: text to draw
     - parameter edgeInsets: edge insets
     - parameter font:       text font
     - parameter color:      text color
     
     - returns: image with added text
     */
    func imageWithText(text: String, edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0), font: UIFont = UIFont.boldArialFontOfSize(10.5), color: UIColor = UIColor.whiteColor()) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        self.drawAtPoint(CGPointZero)
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.alignment = .Center
        let textString: NSAttributedString = NSAttributedString(string: text, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: style])
        textString.drawInRect(CGRectMake(edgeInsets.left, edgeInsets.top, self.size.width - edgeInsets.left - edgeInsets.right, self.size.height - edgeInsets.top - edgeInsets.bottom))
        let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
}

/**
 * ios8 separator inset fix
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class ZeroMarginsCell: UITableViewCell {
    override var layoutMargins: UIEdgeInsets {
        get { return UIEdgeInsetsZero }
        set(newVal) {}
    }
}

/**
 * ios8 separator inset fix
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class ZeroMarginsTableView : UITableView {
    override var layoutMargins: UIEdgeInsets {
        get { return UIEdgeInsetsZero }
        set(newVal) {}
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
 * Shortcut methods for UICollectionView
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
extension UICollectionView {
    
    /**
     Get cell of given class for indexPath
     
     - parameter indexPath: the indexPath
     - parameter cellClass: a cell class
     
     - returns: a reusable cell
     */
    func getCell<T: UICollectionViewCell>(indexPath: NSIndexPath, ofClass cellClass: T.Type) -> T {
        let className = String.stringFromClass(cellClass)
        return self.dequeueReusableCellWithReuseIdentifier(className, forIndexPath: indexPath) as! T
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
 * Circle view
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
extension UIView {
 
    /**
     masks against circle
     */
    func maskCircle() {
        self.layer.cornerRadius = self.bounds.width/2
        self.layer.masksToBounds = true
    }
    
}

/// type alias for image request callback
typealias ImageCallback = (UIImage?)->()

/**
 * Class for storing in-memory cached images
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class UIImageCache {
    
    /// Cache for images
    private var CachedImages = [String: (UIImage?, [ImageCallback])]()
    
    /// the singleton
    class var sharedInstance: UIImageCache {
        struct Singleton { static let instance = UIImageCache() }
        return Singleton.instance
    }
}


/**
 * Image loading
 *
 * - author: Nikita Rodin
 * - version: 1.0
 *
 */
extension UIImage {
    
    /**
     Get image from given view
     
     :param: view the view
     
     :returns: UIImage
     */
    class func imageFromView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: false)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /**
     Load image asynchronously
     
     - parameter url:      image URL
     - parameter callback: the callback to return the image
     */
    class func loadFromURLAsync(url: NSURL, callback: ImageCallback) {
        let key = url.absoluteString
        
        // If there is cached data, then use it
        if let data = UIImageCache.sharedInstance.CachedImages[key] {
            if data.1.isEmpty { // Is image already loadded, then use it
                callback(data.0)
            }
            else { // If image is not yet loaded, then add callback to the list of callbacks
                var savedCallbacks: [ImageCallback] = data.1
                savedCallbacks.append(callback)
                UIImageCache.sharedInstance.CachedImages[key] = (nil, savedCallbacks)
            }
            return
        }
        // If the image is first time requested, then load it
        UIImageCache.sharedInstance.CachedImages[key] = (nil, [callback])
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            
            NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { callback(nil); return }
                    if let image = UIImage(data: data) {
                        
                        // Notify all callbacks
                        for callback in UIImageCache.sharedInstance.CachedImages[key]!.1 {
                            callback(image)
                        }
                        UIImageCache.sharedInstance.CachedImages[key] = (image, [])
                        return
                    }
                    else {
                        print("ERROR: Error occured while creating image from the data: \(data)")
                    }
                }
                }.resume()
        })
    }
    
    /**
     Load image asynchronously.
     More simple method than loadFromURLAsync() that helps to cover common fail cases
     and allows to concentrate on success loading.
     
     - parameter urlString: the url string
     - parameter callback:  the callback to return the image
     */
    class func loadAsync(urlString: String?, callback: ImageCallback) {
        if let urlStr = urlString {
            if urlStr.hasPrefix("http") {
                if let url = NSURL(string: urlStr) {
                    UIImage.loadFromURLAsync(url, callback: { (image: UIImage?) -> () in
                        callback(image)
                    })
                    return
                }
                else {
                    print("ERROR: Wrong URL: \(urlStr)")
                    callback(nil)
                }
            }
                // If urlString is not real URL, then try to load image from assets
            else if let image = UIImage(named: urlStr) {
                callback(image)
            }
        }
        else {
            callback(nil)
        }
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
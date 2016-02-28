//
//  UIViewControllerExt.swift
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright (c) 2016 Toptal. All rights reserved.
//

import UIKit

/**
* Extension for embedding view controllers
*
* - author: Nikita Rodin
* - version: 1.0
*/
extension UIViewController {
    
    /**
    Removes self from parent VC
    */
    func removeFromParent() {
        self.willMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    /**
    Embeds a child view controller into a view. Sets the parent-child view controller relashionships
    
    :param: childVC the embedded view controller
    :param: containerView view to embed into
    :param: frame optional frame of the embeded view, defaults to containerView bounds
    */
    func embedChild(childVC: UIViewController, intoView containerView: UIView, frame: CGRect? = nil) {
        let childView = childVC.view
        childView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        childView.translatesAutoresizingMaskIntoConstraints = true
        childView.frame = frame == nil ? containerView.bounds : frame!
        
        // Add new VC and its view to container VC
        self.addChildViewController(childVC)
        containerView.addSubview(childView)
        
        // Finally notify the child view
        childVC.didMoveToParentViewController(self)
    }
    
}

/**
* Extension to display alerts
*
* - author: Nikita Rodin
* - version: 1.0
*/
extension UIViewController {
	
	/**
	displays alert with specified title & message
	
	:param: message alert message
	:param: title alert title
	*/
	func showAlert(message: String, title: String = "") {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
			alert.dismissViewControllerAnimated(true, completion: nil)
		}))
		self.presentViewController(alert, animated: true, completion: nil)
	}
}


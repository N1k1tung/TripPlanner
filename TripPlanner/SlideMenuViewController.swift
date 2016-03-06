//
//  SlideMenuViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/1/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 * Represents the slide menu view controller class
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class SlideMenuViewController: UIViewController, UIGestureRecognizerDelegate {

    /// root navigation controller
    let containerNavigationController : UINavigationController
    /// left view controller (menu)
    let leftViewController : UIViewController
    /// side menu is collapsed or not
    var collapsed = true
    /// view which will cover containerNavigationController when open
    let coverView = UIView()
    /// shadow view which hovers above menu
    let shadowView = UIView()
    /// pan gesture recognizer
    let panGestureRecognizer = UIPanGestureRecognizer()
    /// how much of the containerNavigationController has to be visible when open
    var expandOffset: CGFloat = IS_IPAD ? SCREEN_SIZE.width*3/4 : 57.0
    /// when left edge of container view reach this point while opening, side menu will be shown otherwise it will be closed back
    var openOffset: CGFloat = IS_IPAD ? SCREEN_SIZE.width/10 : SCREEN_SIZE.width/5
    /// when left edge of container view reach this point while closing, side menu will be closed otherwise it will be opened back
    var closeOffset: CGFloat = IS_IPAD ? SCREEN_SIZE.width*1/5 : SCREEN_SIZE.width*2/3
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadChildController(leftViewController, inContentView: self.view)
        loadChildController(containerNavigationController, inContentView: self.view)
        
        // pan gesture
        panGestureRecognizer.addTarget(self, action: "handlePan:")
        containerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        
        // add invisible cover
        containerNavigationController.view.addSubview(coverView)
        coverView.translatesAutoresizingMaskIntoConstraints = false
        containerNavigationController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: ["view": coverView]))
        containerNavigationController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: ["view": coverView]))
        containerNavigationController.view.sendSubviewToBack(coverView)
        coverView.backgroundColor = UIColor.clearColor()
        
        // add dismiss on tap when open
        let tapGesture = UITapGestureRecognizer(target: self, action: "toggleSideMenu")
        coverView.addGestureRecognizer(tapGesture)
        
        // show shadow
        shadowView.layer.shadowRadius = 7
        shadowView.layer.shadowOffset = CGSizeMake(-6, 0)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: ["view": shadowView]))
        shadowView.addConstraint(NSLayoutConstraint(item: shadowView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: 12))
        self.view.addConstraint(NSLayoutConstraint(item: shadowView, attribute: .Leading, relatedBy: .Equal, toItem: containerNavigationController.view, attribute: .Leading, multiplier: 1, constant: 0))
        self.view.bringSubviewToFront(containerNavigationController.view)

    }
    
    /**
     view rotation
     */
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        if IS_IPAD {
            expandOffset = size.width*3/4
            openOffset = size.width/10
            closeOffset = size.width*1/5
        }
    }
    
    /**
     toggles side menu
     */
    func toggleSideMenu() {
        animate(collapsed)
    }
    
    /**
     animates left view controller
     
     :param: open true if it should be opened, false if closed
     */
    func animate(open: Bool) {
        if (open) {
            collapsed = false
            containerNavigationController.view.bringSubviewToFront(coverView)
            animatePosition(true, completion: nil)
        } else {
            animatePosition(false) { finished in
                self.collapsed = true
            }
        }
    }
    
    /**
     Method animating position of containerViewController
     
     :param: open       true to open, false to close
     :param: completion completion handler
     */
    func animatePosition(open : Bool, completion: ((Bool) -> ())?) {
        let targetPosition: CGFloat = open ? containerNavigationController.view.frame.width - expandOffset : 0.0
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: { () -> Void in
            self.containerNavigationController.view.frame.origin.x = targetPosition
            self.shadowView.frame.origin.x = targetPosition
            }) { (finished) -> Void in
                
                if !open {
                    self.containerNavigationController.view.sendSubviewToBack(self.coverView)
                }
                if let aCompletion = completion {
                    aCompletion(finished)
                }
        }
    }
    
    /**
     when gesture occures and changes state this handler is moving views
     
     :param: gestureRecognizer gesture recognizer
     */
    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        switch(gestureRecognizer.state) {
        case .Began:
            break
        case .Changed:
            if containerNavigationController.view.frame.origin.x > 0 {
                containerNavigationController.view.bringSubviewToFront(coverView)
            } else
            {
                containerNavigationController.view.sendSubviewToBack(coverView)
            }
            
            let newCenterX = gestureRecognizer.view!.center.x + gestureRecognizer.translationInView(view).x
            if newCenterX > self.view.center.x {
                gestureRecognizer.view!.center.x = gestureRecognizer.view!.center.x + gestureRecognizer.translationInView(view).x
                gestureRecognizer.setTranslation(CGPointZero, inView: self.view)
                shadowView.frame.origin.x = gestureRecognizer.view!.frame.minX
            }
        case .Ended:
            if collapsed  {
                animate(gestureRecognizer.view!.frame.origin.x > openOffset)
            }
            else {
                animate(gestureRecognizer.view!.frame.origin.x > closeOffset)
            }
        default:
            break
        }
    }

    /**
    Creates new instance

    - parameter leftSideController:  The left side controller
    - parameter defaultContent:      The default content

    - returns: the created instance
    */
    init(leftSideController: UIViewController, defaultContent: UIViewController) {
        leftViewController = leftSideController
        containerNavigationController = defaultContent is UINavigationController ? defaultContent as! UINavigationController : defaultContent.wrapInNavigationController()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    /**
    Fail create from nib

    - parameter aDecoder: The a decoder
    */
    required init?(coder aDecoder: NSCoder) {
        leftViewController = UIViewController()
        containerNavigationController = UINavigationController()
        assertionFailure("initWithCoder: is not supported")

        super.init(coder: aDecoder)
    }

    /**
    Set content view controller

    - parameter newController: The new controller
    */
    func setContentViewController(newController: UIViewController) {
        containerNavigationController.setViewControllers([newController], animated: false)
        animate(false)
    }
    
    /**
     Confirms logout action and performs logout if needed
     */
    func confirmLogout() {
        let alert = UIAlertController(title: "Confirm".localized, message: "Are you sure you want to log out?".localized, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Yes".localized, style: UIAlertActionStyle.Destructive, handler: { (_) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
            LoginDataStore.sharedInstance.logout()
            self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No".localized, style: UIAlertActionStyle.Cancel, handler: { (_) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    
    // MARK: - gesture recognizer delegate
    
    /**
     filters touches when collapsed
     */
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if gestureRecognizer.state == .Possible && collapsed {
            return touch.locationInView(gestureRecognizer.view).x < (IS_IPAD ? 250 : 160)
        }
        return true
    }
}

/**
 * Relevant extensions for contained controllers
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
extension UIViewController {
    
    /// gets the slide menu controller
    var slideMenuController: SlideMenuViewController? {
        var parent: UIViewController? = self
        while (parent != nil) {
            if let parent = parent as? SlideMenuViewController {
                return parent
            }
            parent = parent?.parentViewController
        }
        return nil
    }

    /**
    Show controller for storyboard name and identifier.
    
    - parameter storyboardName: The storyboard name parameter.
    - parameter identifier:     The identifier parameter.
    */
    func showController(storyboardName storyboardName: String, identifier: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(identifier) 
        slideMenuController?.setContentViewController(controller.wrapInNavigationController())
    }
    
    /**
    Show left side menu button tapped.
    */
    @IBAction func showLeftSideMenuButtonTapped() {
        slideMenuController?.toggleSideMenu()
    }
 
    /**
     Add menu button
     */
    func addMenuButton() {
        let menuBtn = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: "showLeftSideMenuButtonTapped")
        self.navigationItem.leftBarButtonItem = menuBtn
    }

}
//
//  SlideMenuViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/1/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 * Slide menu delegate
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
protocol SlideMenuSideWidthDelegate: class
{
    /**
    Gets left slide menu width.

    - returns: the width.
    */
    func slideLeftMenuSideWidth() -> CGFloat
    
}

/**
 * Represents the slide menu view controller class
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class SlideMenuViewController: UIViewController {

    /**
    Gets the sliding state.

    - LeftOpen:			The Left Open
    - Collapsed:		The Collapsed
    - LeftOpening:		The Left Opening
    - LeftClosing:		The Left Closing
    - Interactive:		The Interactive
    */
    enum SlideState {
        case LeftOpen
        case Collapsed
        case LeftOpening
        case LeftClosing
        case Interactive
    }

    /// Gets the state.
    var state: SlideState = .Collapsed {
        didSet {
            for view in contentView.subviews {
                view.userInteractionEnabled = state == .Collapsed
            }
            swipeRightGesture.enabled = state != .LeftOpen
            interactiveEdgeGesture.enabled = state != .LeftOpen
            tapGesture.enabled = state == .LeftOpen
        }
    }

    /// Gets the width delegate.
    weak var widthDelegate: SlideMenuSideWidthDelegate?

    /// Gets the left side controller
    let leftSideController: UIViewController
    /// Gets the content controller
    var contentController: UIViewController
    /// Gets the animation duration
    var animationDuration = 0.3

    /// Gets the content view
    var contentView = UIView()
    /// Gets the content left constraint
    var contentLeft: NSLayoutConstraint!

    /// Gets the interactive gesture recognizer.
    var interactiveEdgeGesture = UIScreenEdgePanGestureRecognizer()
    /// Gets the swipe  gesture recognizer
    var swipeRightGesture = UISwipeGestureRecognizer()
    /// Gets the swipe gesture recognizer
    var swipeLeftGesture = UISwipeGestureRecognizer()
    /// Gets the tap gesture recognizer
    var tapGesture = UITapGestureRecognizer()
    /// Gets the interactive width
    var interactiveWidth = CGFloat(0)

    /**
    Creates new instance.

    - parameter leftSideController:  The left side controller
    - parameter defaultContent:      The default content
    - parameter widthDelegate:       The width delegate

    - returns: the created instance.
    */
    init(leftSideController: UIViewController, defaultContent: UIViewController, widthDelegate: SlideMenuSideWidthDelegate) {
        self.leftSideController = leftSideController
        self.contentController = defaultContent
        self.widthDelegate = widthDelegate

        tapGesture.enabled = false
        swipeRightGesture.direction = .Right
        swipeLeftGesture.direction = .Left
        interactiveEdgeGesture.edges = [.Left, .Right]

        contentView.addGestureRecognizer(swipeRightGesture)
        contentView.addGestureRecognizer(swipeLeftGesture)
        contentView.addGestureRecognizer(interactiveEdgeGesture)
        contentView.addGestureRecognizer(tapGesture)

        super.init(nibName: nil, bundle: nil)

        // add the left side controller
        addChildViewController(leftSideController)
        leftSideController.didMoveToParentViewController(self)
        leftSideController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftSideController.view)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|",
            options: [], metrics: nil, views: ["view" : leftSideController.view]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view(==menuWidth)]",
            options: [], metrics: ["menuWidth":leftMenuWidth()], views: ["view" : leftSideController.view]))

        // add the content view
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        contentLeft = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal, toItem: view,
            attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        view.addConstraint(contentLeft)
        view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal, toItem: contentView,
            attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|",
            options: [], metrics: nil, views: ["view" : contentView]))

        // create the gestures
        swipeRightGesture.addTarget(self, action: "swipeRightGestureRecognizerFired")
        swipeLeftGesture.addTarget(self, action: "swipeLeftGestureRecognizerFired")
        interactiveEdgeGesture.addTarget(self, action: "viewPanned:")
        tapGesture.addTarget(self, action: "hideSideMenu")

        setContentViewController(defaultContent)
    }
    
    /**
    Always fail, as it is required to be used in code.

    - parameter aDecoder: The a decoder

    - returns: always fails.
    */
    required init?(coder aDecoder: NSCoder) {
        leftSideController = UIViewController()
        contentController = UIViewController()
        assertionFailure("SlideMenuViewController works only with code")

        super.init(coder: aDecoder)
    }

    /**
    the left menu width.
    
    - returns: the width.
    */
    func leftMenuWidth() -> CGFloat {
        return widthDelegate?.slideLeftMenuSideWidth() ?? view.bounds.width - 40
    }
    
    /**
    Called by gesture recognizer
    hide left side if it's already open
    */
    func swipeLeftGestureRecognizerFired() {
        if state == .LeftOpen {
            hideSideMenu()
        }
    }

    /**
    Called by gesture recognizer
    open left side menu
    */
    func swipeRightGestureRecognizerFired() {
        if state == .Collapsed {
            showLeftSideMenu()
        }
    }

    /**
    Show left side menu.
    */
    func showLeftSideMenu(callback: (()->())? = nil) {
        if state != .Collapsed {
            return
        }
        
        state = .LeftOpening
        view.insertSubview(leftSideController.view, belowSubview: contentView)
        contentLeft.constant = leftMenuWidth()
        UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,
            options: [], animations: { () -> Void in
                self.view.layoutIfNeeded()
            }) { (finished) -> Void in
                self.state = .LeftOpen
                callback?()
        }
    }

    /**
    Hide side menu.
    */
    func hideSideMenu() {
        if state != .LeftOpen {
            return
        }
        
        // hide the keyboard
        if let firstResponder = self.view.findFirstResponder() {
            firstResponder.resignFirstResponder()
        }
        
        state = .LeftClosing
        contentLeft.constant = 0
        
        UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0,
            options: [], animations: { () -> Void in
                self.view.layoutIfNeeded()
            }) { (finished) -> Void in
                self.state = .Collapsed
        }
    }

    /**
    View has been panned.

    - parameter gesture: The gesture
    */
    func viewPanned(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            state = .Interactive
        case .Changed:
            let translation = gesture.translationInView(gesture.view!).x
            contentLeft.constant = max(leftMenuWidth(), translation)

            view.layoutIfNeeded()
        case .Ended:
            
            var percentage : CGFloat = 0
            if contentLeft.constant > 0 {
                percentage = min(1, (leftMenuWidth() - contentLeft.constant) / leftMenuWidth())
                view.insertSubview(leftSideController.view, belowSubview: contentView)
            }
            
            let willShow = percentage < 0.7
            let leftCaseConstant = willShow ? leftMenuWidth() : 0
            
            contentLeft.constant = leftCaseConstant

            UIView.animateWithDuration(
                animationDuration * Double(abs(percentage)),
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0,
                options: UIViewAnimationOptions(),
                animations: { () -> Void in
                    self.view.layoutIfNeeded()
                }) { (finished) -> Void in
                    if self.contentLeft.constant == 0 {
                        self.state = .Collapsed
                    }
                    else {
                        self.state = .LeftOpen
                    }
                    
            }

        case .Cancelled, .Failed, .Possible:
            // cancel, failed close

            contentLeft.constant = 0
            UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0,
                options: [], animations: { () -> Void in
                    self.view.layoutIfNeeded()
                }) { (finished) -> Void in
                    self.state = .Collapsed
            }
        }
    }

    /**
    Set content view controller.

    - parameter newController: The new controller
    */
    func setContentViewController(newController: UIViewController) {
        // delete old
        if contentController.parentViewController != nil {
            unloadChildController(contentController)
        }

        contentController = newController

        // add the new
        loadChildController(contentController, inContentView: contentView)
        
        hideSideMenu()
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
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

/**
 * Relevant extensions for contained controllers
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
extension UIViewController {
    
    /// gets the slide menu controller.
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
        self.slideMenuController?.setContentViewController(controller.wrapInNavigationController())
    }
    
    /**
    Show left side menu button tapped.
    */
    @IBAction func showLeftSideMenuButtonTapped() {
        slideMenuController?.showLeftSideMenu()
    }
 
    /**
     Add menu button
     */
    func addMenuButton() {
        let menuBtn = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: "showLeftSideMenuButtonTapped")
        self.navigationItem.leftBarButtonItem = menuBtn
    }

}
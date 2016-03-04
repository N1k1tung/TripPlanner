//
//  PopoverViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/3/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 *  represents value in popover protocol
 */
@objc
protocol Value {
    var title: String { get set }
    var image: String? { get set }
}

/**
 *  simple value
 */
class SimpleValue: NSObject, Value {
    var title: String
    var image: String?
    
    init(title: String, image: String?) {
        self.title = title
        self.image = image
    }
}

/**
 *  represents filter
 */
class Filter: NSObject, Value {
    var title: String
    var image: String?
    var filter: ([AnyObject]) -> [AnyObject]
    
    init(title: String, image: String?, filter: ([AnyObject]) -> [AnyObject]) {
        self.title = title
        self.image = image
        self.filter = filter
    }
}


// reference to the last opened popover
var lastPopover: UIPopoverController?

/// the width of the popover
let POPOVER_WIDTH: CGFloat = 280

 /**
 * displays popover on iPad & an action sheet on iPhone
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
extension UIPopoverController {
   
    /**
    displays popover with specifed data from specified bar item
    
    - parameter title: popover title
    - parameter values: popover items
    - parameter selectedValue: selected or nil
    - parameter fromBarButtonItem: anchor bar button
    - parameter onSelect: selection handler
    */
    class func showPopover(title: String, values: [Value], selectedValue: Value?,
        fromBarButtonItem item: UIBarButtonItem, onSelect: (Value) -> Void) {
            
            // prepare table
            let vc = UIStoryboard(name: "Popovers", bundle: nil).instantiateViewControllerWithIdentifier("PopoverTableVC")
                as! PopoverTableVC
            vc.values = values
            vc.selected = selectedValue
            vc.title = title
            
            if IS_IPAD {
                if let _ = lastPopover {
                    lastPopover?.dismissPopoverAnimated(true)
                    lastPopover = nil
                }
                
                // prepare popover
                let popover = UIPopoverController(contentViewController: vc)
                popover.popoverBackgroundViewClass = PopoverBackgroundView.self
                popover.popoverContentSize = CGSizeMake(POPOVER_WIDTH, 235)
                
                vc.onSelect = { (f: Value) in
                    popover.dismissPopoverAnimated(true)
                    onSelect(f)
                }
                
                // present
                popover.presentPopoverFromBarButtonItem(item, permittedArrowDirections: .Any, animated: true)
                // disable other navigation items while presented
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                    popover.passthroughViews = nil
                }
                
                lastPopover = popover

            } else
            { // iPhone
                // prepare popover
                let popover = PopoverBackgroundViewController(size: CGSizeMake(IS_LANDSCAPE ? SCREEN_SIZE.height : SCREEN_SIZE.width, 235))
                popover.view.alpha = 0
                popover.loadChildController(vc, inContentView: popover.contentView)
                
                vc.onSelect = { (f: Value) in
                    popover.dismiss()
                    onSelect(f)
                }
                
                RootContainerController?.showViewControllerAsPopover(popover)
                
                // present
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    popover.view.alpha = 1
                })
            }
            

    }
    
}

/**
 * Table displaying popover content
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class PopoverTableVC: UITableViewController {
    
    // available filters
    var values: [Value] = []
    
    // currently selected
    var selected: Value?
    
    // on select
    var onSelect: ((Value) -> Void)?
    
    // outlets
    @IBOutlet weak var titleLabel: UILabel!

    /**
    Initialize the view after a load
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLabel.text = self.title
        self.tableView.bounces = false
    }
    
    // MARK: - table view ds & delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let value = values[indexPath.row]
        self.selected = value
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        onSelect?(value)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
        // configure cell
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let value = values[indexPath.row]
        
        if let image = value.image {
            cell.imageView?.image = UIImage(named: image)
        }
        cell.textLabel?.text = value.title
        cell.accessoryType = (value.title == selected?.title) ? .Checkmark : .None
        
        return cell
    }
    
}

/**
 * Popover background
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class PopoverBackgroundView: UIPopoverBackgroundView {
    
    /// arrow image
    var arrow: UIImageView!
    /// bg
    var bg: UIView!
    /// dim
    var dimBG: UIView!
    
    /// arrow base width
    override class func arrowBase() -> CGFloat {
        return 37
    }
    /// arrow arrow height
    override class func arrowHeight() -> CGFloat {
        return 23
    }
    
    /**
    common initializer for all required inits
    */
    func commonInit() {
        // dim
        let size = UIScreen.mainScreen().bounds
        let allScreen = CGRectMake(-size.width, -size.height, size.width*3, size.height*3)
        self.dimBG = UIView(frame: allScreen)
        dimBG.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.addSubview(dimBG)
        
        // arrow
        self.arrow = UIImageView(image: UIImage(named: "popover_arrow_up"))
        arrow.center.y = PopoverBackgroundView.arrowHeight()/2
        self.addSubview(arrow)
        
        // white rect bg
        var frame = self.bounds
        frame.origin.y = PopoverBackgroundView.arrowHeight()
        frame.size.height -= PopoverBackgroundView.arrowHeight()
        self.bg = UIView(frame: frame)
        bg.backgroundColor = UIColor.whiteColor()
        self.addSubview(bg)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }

    /// up arrow
    override var arrowDirection: UIPopoverArrowDirection {
        get {
           return UIPopoverArrowDirection.Up
        }
        set {
            
        }
    }
    
    /// current arrow offset
    override var arrowOffset: CGFloat {
        get {
            return -arrow.center.x + POPOVER_WIDTH / 2
        }
        set {
            arrow.center.x = self.center.x + newValue
        }
    }
    
    override func layoutSubviews() {
    }
    
}

/**
 * Popover background controller for iPhones
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class PopoverBackgroundViewController: UIViewController {
    
    /// content size
    var size: CGSize
    
    /**
     designated initializer
     
     - parameter size: content size
     */
    init(size: CGSize) {
        self.size = size
        super.init(nibName: nil, bundle: nil)
    }

    /**
     required init stub
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// content view
    var contentView: UIView!
    /// dim
    var dimBG: UIView!
    
    /**
     view did load handler
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        // dim all but toolbar
        let dimFrame = CGRectMake(0, 0, IS_LANDSCAPE ? SCREEN_SIZE.height : SCREEN_SIZE.width, self.view.bounds.height-44)
        self.dimBG = UIView(frame: dimFrame)
        dimBG.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        dimBG.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.addSubview(dimBG)
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismiss")
        dimBG.addGestureRecognizer(tapGesture)
        
        // white rect bg
        let frame = CGRectMake(0, self.view.bounds.height-size.height, size.width, size.height)
        self.contentView = UIView(frame: frame)
        contentView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        contentView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(contentView)
        
        // subscribe to keyboard notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyboard:"),
            name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyboard:"),
            name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willHideKeyboard:"),
            name: UIKeyboardWillHideNotification, object: nil)

    }
    
    /**
     cleanup
     */
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     dismiss
     */
    func dismiss() {
        self.view.endEditing(true)
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.alpha = 0
        }
        self.removeFromParentViewController()
    }
    
    // MARK: - keyboard notifications
    
    /**
    keyboard will show notification handler
    
    - parameter notif: notification info
    */
    func willShowKeyboard(notif: NSNotification) {
        let rect = (notif.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight = min(rect.height, rect.width)
        UIView.animateWithDuration(0.3) {
            self.contentView.frame.origin.y = self.view.bounds.height-self.size.height-keyboardHeight
        }
    }
    
    /**
     keyboard will hide notification handler
     
     - parameter notif: notification info
     */
    func willHideKeyboard(notif: NSNotification) {
        UIView.animateWithDuration(0.3) {
            self.contentView.frame.origin.y = self.view.bounds.height-self.size.height
        }
    }
    
    
}
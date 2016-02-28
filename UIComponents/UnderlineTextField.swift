//
//  UnderlineTextField
//
//  Created by Nikita Rodin on 1/9/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 * label with underline
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
@IBDesignable
public class UnderlineTextField: UITextField {
    
    /// underline color
    @IBInspectable public var underlineColor: UIColor = UIColor.fromString("B7BEC1")!

    /// underline color during error highlight
    @IBInspectable public var errorColor: UIColor = UIColor.redColor()

    /// toggles error highlight
    public var showError = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /**
     awake from nib
     */
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.placeholderColor = UIColor.lightGray()
        self.keyboardAppearance = .Dark
        self.autocorrectionType = .No
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChanged:", name: UITextFieldTextDidChangeNotification, object: self)
    }
    
    /**
     draw rect
     */
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let ctx = UIGraphicsGetCurrentContext()
        if showError {
            errorColor.setFill()
        } else
        {
            underlineColor.setFill()
        }
        CGContextFillRect(ctx, CGRectMake(0.0, rect.size.height - 5.0, rect.size.width, 0.5))
    }
    
    /**
     text change notification
     
     - parameter notif: notification data
     */
    public func textChanged(notif: NSNotification) {
        self.showError = false
    }
    
    /**
     cleanup
     */
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
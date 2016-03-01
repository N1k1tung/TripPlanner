//
//  TripDetailsViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/28/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import MapKit

/**
 * Trip details screen
 *
 * - author: TCCODER
 * - version: 1.0
 */
class TripDetailsViewController: UIViewController {

    /// outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeStartLabel: UILabel!
    @IBOutlet weak var timeEndLabel: UILabel!
    @IBOutlet weak var pickerOffset: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
    /// indicates date picker selection
    var pickingStart = false
    
    /// model values used to store changed options
    var timeStartValue: NSDate = NSDate() {
        didSet {
            updateLabelWithValue(timeStartLabel, value: timeStartValue, formatter: Static.dateFormetter)
        }
    }
    var timeEndValue: NSDate = NSDate() {
        didSet {
            updateLabelWithValue(timeEndLabel, value: timeEndValue, formatter: Static.dateFormetter)
        }
    }
    
    /**
     *  Date formatter
     */
    struct Static {
        static var dateFormetter: NSDateFormatter = {
            let f = NSDateFormatter()
            f.locale = NSLocale.autoupdatingCurrentLocale()
            f.dateStyle = .MediumStyle
            f.timeStyle = .NoStyle
            return f
        }()
    }
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layer.borderColor = UIColor.lightGray().CGColor
        textView.layer.borderWidth = 0.5
    }
    
    /**
     Update date value in the given label
     
     - parameter label:     the label
     - parameter value:     the value
     - parameter formetter: the number formetter
     */
    func updateLabelWithValue(label: UILabel, value: NSDate?, formatter: NSDateFormatter) {
        if let date = value {
            label.text = formatter.stringFromDate(date)
        } else
        {
            label.text = "-"
        }
    }
    
    /**
     picker time changes
     
     - parameter sender: the date picker
     */
    @IBAction func timeChanged(sender: UIDatePicker) {
        if pickingStart {
            timeStartValue = sender.date
            if timeStartValue.compare(timeEndValue) == .OrderedDescending {
                timeEndValue = timeStartValue
            }
        } else
        {
            timeEndValue = sender.date
            if timeStartValue.compare(timeEndValue) == .OrderedDescending {
                timeStartValue = timeEndValue
            }
        }
    }
    
    /**
     pick start time with picker
     
     - parameter sender: the button
     */
    @IBAction func pickStartTime(sender: AnyObject) {
        pickingStart = true
        datePicker.date = timeStartValue
        self.showPicker(true)
    }
    
    /**
     pick end time with picker
     
     - parameter sender: the button
     */
    @IBAction func pickEndTime(sender: AnyObject) {
        pickingStart = false
        datePicker.date = timeEndValue
        self.showPicker(true)
    }
    
    /**
     Save button tap handler
     
     - parameter sender: the button
     */
    @IBAction func saveButtonAction(sender: AnyObject) {

        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    /**
     shows/hides time picker
     
     - parameter show: true to show, false to hide
     */
    func showPicker(show: Bool) {
        if !show && pickerOffset.constant == 0 { // hide
            UIView.animateWithDuration(0.3) {
                self.pickerOffset.constant = -self.pickerView.frame.height
                self.pickerView.layoutIfNeeded()
            }
        } else if show && pickerOffset.constant == -pickerView.frame.height { // show
            UIView.animateWithDuration(0.3) {
                self.pickerOffset.constant = 0
                self.pickerView.layoutIfNeeded()
            }
        }
    }
    
    /**
     done tap handler
     
     - parameter sender: the button
     */
    @IBAction func doneTapped(sender: AnyObject) {
        self.showPicker(false)
    }


}

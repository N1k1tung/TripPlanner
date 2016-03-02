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
class TripDetailsViewController: UIViewController, UITextViewDelegate {

    /// trip to edit
    var trip: Trip!
    
    /// save handler
    var onSave: ((Trip) -> Void)?
    
    /// outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var destinationLabel: UILabel!
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
            updateLabelWithValue(timeStartLabel, value: timeStartValue)
        }
    }
    var timeEndValue: NSDate = NSDate() {
        didSet {
            updateLabelWithValue(timeEndLabel, value: timeEndValue)
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
        
        // update UI
        if let trip = trip {
            destinationLabel.text = trip.destination?.0 ?? "-"
            // add pin
            if let location = trip.destination?.1 {
                let point = MKPointAnnotation()
                point.coordinate = location
                mapView.addAnnotation(point)
                mapView.showAnnotations([point], animated: false)
            }
            textView.text = trip.comment
        } else
        {
            trip = Trip()
        }
        timeStartValue = trip.startDate ?? NSDate()
        timeEndValue = trip.endDate ?? NSDate()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save".localized, style: .Plain, target: self, action: "doneTapped")
        
        // dismiss keyboard on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: "endEditing")
        self.view.addGestureRecognizer(tapGesture)
    }
    
    /**
     Update date value in the given label
     
     - parameter label:     the label
     - parameter value:     the value
     */
    func updateLabelWithValue(label: UILabel, value: NSDate?) {
        if let date = value {
            label.text = Static.dateFormetter.stringFromDate(date)
        } else
        {
            label.text = "-"
        }
    }
    
    // MARK: - actions
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
        showPicker(true)
    }
    
    /**
     pick end time with picker
     
     - parameter sender: the button
     */
    @IBAction func pickEndTime(sender: AnyObject) {
        pickingStart = false
        datePicker.date = timeEndValue
        showPicker(true)
    }
    
    /**
     shows/hides time picker
     
     - parameter show: true to show, false to hide
     */
    func showPicker(show: Bool) {
        if !show && pickerOffset.constant == 0 {
            // hide
            UIView.animateWithDuration(0.3) {
                self.pickerOffset.constant = -self.pickerView.frame.height
                self.pickerView.layoutIfNeeded()
            }
        } else if show && pickerOffset.constant == -pickerView.frame.height {
            // show
            textView.resignFirstResponder()
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

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? SelectLocationViewController {
            vc.destination = trip.destination
            vc.onSelect = { (dst) in
                self.trip.destination = dst
                self.destinationLabel.text = dst?.0 ?? "-"
                // add new pin
                if let location = dst?.1 {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    let point = MKPointAnnotation()
                    point.coordinate = location
                    self.mapView.addAnnotation(point)
                    self.mapView.showAnnotations([point], animated: false)
                }
            }
        }
    }
    
    /**
     done tap handler
     */
    func doneTapped() {
        if validate() {
            trip.startDate = timeStartValue
            trip.endDate = timeEndValue
            trip.comment = textView.text
            onSave?(trip!)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    /**
     ends editing
     */
    func endEditing() {
        textView.resignFirstResponder()
    }
    
    /**
     validates trip
     
     - returns: validation result
     */
    func validate() -> Bool {
        if trip.destination == nil {
            showAlert("Please select destination".localized)
            return false
        }
        
        return true
    }

    // MARK: - text view delegate
    func textViewDidBeginEditing(textView: UITextView) {
        showPicker(false)
    }
    
}

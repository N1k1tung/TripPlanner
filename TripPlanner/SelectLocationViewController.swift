//
//  SelectLocationViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/2/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import PKHUD

/**
 * Select location screen
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class SelectLocationViewController: UIViewController, MKMapViewDelegate {

    /// outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var destinationLabel: UILabel!

    /// geocoder
    let geocoder = CLGeocoder()
    
    /// destination
    var destination: (String, CLLocationCoordinate2D)?
    
    /// selection handler
    var onSelect: (((String, CLLocationCoordinate2D)?) -> Void)?
    
    /// help
    let helpText = "Press on map".localized
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let longPress = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        longPress.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPress)
        destinationLabel.text = destination?.0 ?? helpText
        if let location = destination?.1 {
            let point = MKPointAnnotation()
            point.coordinate = location
            mapView.addAnnotation(point)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done".localized, style: .Plain, target: self, action: "doneTapped")
    }
    
    /**
     handles long press
     
     - parameter gesture: gesture recognizer
     */
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .Began {
            mapView.removeAnnotations(mapView.annotations)
            let point = MKPointAnnotation()
            point.coordinate = mapView.convertPoint(gesture.locationInView(mapView), toCoordinateFromView: mapView)
            mapView.addAnnotation(point)
            geocodeLocation(point.coordinate)
        }
    }
    
    /**
     reverse geocoding
     
     - parameter coordinate: coordinate
     */
    func geocodeLocation(coordinate: CLLocationCoordinate2D) {
        HUD.show(.Progress)
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { (placemarks: [CLPlacemark]?, error) -> Void in
            HUD.hide(afterDelay: 0, completion: nil)
            if let error = error {
                self.showAlert(error.localizedDescription)
            } else
            {
                if let name = placemarks?.first?.name {
                    self.destination = (name, coordinate)
                    self.destinationLabel.text = name
                } else
                {
                    self.destination = nil
                    self.destinationLabel.text = self.helpText
                }
            }
        }
    }
    
    /**
     done tap handler
     */
    func doneTapped() {
        onSelect?(destination)
        self.navigationController?.popViewControllerAnimated(true)
    }

}
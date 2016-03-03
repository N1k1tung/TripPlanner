//
//  MonthPlanViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/28/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


/**
 * Month plan screen
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class MonthPlanViewController: UIViewController {

    /// data store
    let dataStore = TripsDataStore()
    
    /// trips
    var allTrips: [Trip] = [] {
        didSet {
            reloadMap()
        }
    }
    
    /// outlets
    @IBOutlet weak var mapView: MKMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addMenuButton()
        dataStore.onChange = {
            self.allTrips = self.dataStore.trips
        }
    }
    
    /**
     reloads map
     */
    func reloadMap() {
        // get trips in a month interval since today
        let calendar = NSCalendar.currentCalendar()
        let start = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(), options: []) ?? NSDate()
        let finish = start.dateByAddingTimeInterval(30 * 24 * 3600)
        var trips = allTrips.filter { $0.startDate.compare(start) == .OrderedDescending && $0.startDate.compare(finish) == .OrderedAscending }
        
        // sort by start date
        trips.sortInPlace { $0.startDate.compare($1.startDate) == .OrderedAscending }
        
        // draw travel map
        mapView.removeAnnotations(mapView.annotations)
        var prev: CLLocationCoordinate2D?
        for t in trips {
            if let location = t.destination?.1 {
                let point = MKPointAnnotation()
                point.coordinate = location
                mapView.addAnnotation(point)
                point.title = t.destination?.0
                point.subtitle = dateFormetter.stringFromDate(t.startDate) + " - " + dateFormetter.stringFromDate(t.endDate)
                // add arrow
                if let prev = prev {
                    var coords = [prev, location]
                    let line = MKPolyline(coordinates: &coords, count: coords.count)
                    mapView.addOverlay(line)
                }
                prev = location
            }
        }
        mapView.showAnnotations(mapView.annotations, animated: false)
    }

}

// MARK: - MKMapViewDelegate
extension MonthPlanViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            // customize polylines
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .blueColor()
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        }
        
        return MKOverlayRenderer()
    }
}
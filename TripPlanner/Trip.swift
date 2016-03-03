//
//  Trip.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/2/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import CoreLocation

/**
 * Trip model
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class Trip: NSObject {

    /// fields
    var key: String?
    var destination: (String, CLLocationCoordinate2D)?
    var startDate: NSDate = NSDate()
    var endDate: NSDate = NSDate()
    var comment: String?
    
    /// calculates status
    var status: String {
        if startDate.timeIntervalSinceNow < 0 {
            // already started
            return endDate.timeIntervalSinceNow < 0 ? "Finished".localized : "Started".localized
        } else
        {
            // count days to start
            let calendar = NSCalendar.currentCalendar()
            let days = calendar.components(.Day, fromDate: NSDate(), toDate: startDate, options: []).day
            return "in".localized + " \(days) " + (days == 1 ? "day".localized : "days".localized)
        }
    }
    
    /**
     exports to dictionary
     
     - returns: dictionary
     */
    func toDictionary() -> NSDictionary {
        return [
            "destinationName": destination?.0 ?? "",
            "destinationLat": destination?.1.latitude ?? 0,
            "destinationLong": destination?.1.longitude ?? 0,
            "startDate": requestDateFormetter.stringFromDate(startDate),
            "endDate": requestDateFormetter.stringFromDate(endDate),
            "comment": comment ?? ""
        ]
    }
    
    /**
     empty initializer
     */
    override init() {
        super.init()
    }
    
    /**
     initializer from dictionary
     
     - parameter dictionary: dictionary
     */
    convenience init(dictionary: NSDictionary) {
        self.init()
        
        key = dictionary["key"] as? String
        comment = dictionary["comment"] as? String
        if let name = dictionary["destinationName"] as? String,
            let lat = dictionary["destinationLat"] as? CLLocationDegrees,
            let long = dictionary["destinationLong"] as? CLLocationDegrees {
                destination = (name, CLLocationCoordinate2DMake(lat, long))
        }
        if let date = dictionary["startDate"] as? String {
            startDate = requestDateFormetter.dateFromString(date) ?? NSDate()
        }
        if let date = dictionary["endDate"] as? String {
            endDate = requestDateFormetter.dateFromString(date) ?? NSDate()
        }
    }
    
}

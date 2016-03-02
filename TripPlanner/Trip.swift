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
    var destination: (String, CLLocationCoordinate2D)?
    var startDate: NSDate?
    var endDate: NSDate?
    var comment: String?
    
}

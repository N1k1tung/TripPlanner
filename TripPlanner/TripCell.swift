//
//  TripCell.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/2/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 * Trip cell
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class TripCell: UITableViewCell {

    /// outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    /**
     configures cell with trip info
     
     - parameter trip: trip
     */
    func configure(trip: Trip) {
        titleLabel.text = trip.destination?.0
        if trip.startDate.timeIntervalSinceNow < 0 {
            // already started
            valueLabel.text = trip.endDate.timeIntervalSinceNow < 0 ? "Finished".localized : "Started".localized
        } else
        {
            // count days to start
            let calendar = NSCalendar.currentCalendar()
            let days = calendar.components(.Day, fromDate: NSDate(), toDate: trip.startDate, options: []).day
            valueLabel.text = "in".localized + " \(days) " + (days == 1 ? "day".localized : "days".localized)
        }
    }
    
}

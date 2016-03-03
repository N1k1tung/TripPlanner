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
    @IBOutlet weak var subtitleLabel: UILabel!
    
    /**
     configures cell with trip info
     
     - parameter trip: trip
     */
    func configure(trip: Trip) {
        titleLabel.text = trip.destination?.0
        valueLabel.text = trip.status
        subtitleLabel.text = trip.comment
    }
    
}

//
//  UserCell.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/3/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 * User info cell
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class UserCell: UITableViewCell {

    /// outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    /**
     configures cell with user info
     
     - parameter user: user
     */
    func configure(user: User) {
        titleLabel.text = user.name
        valueLabel.text = user.role.rawValue.localized
        subtitleLabel.text = user.email
    }

}

//
//  MenuTableViewCell.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/1/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 * Side menu cell
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class MenuTableViewCell: UITableViewCell {
    
    /// menu
    var menu : Menu? {
        didSet {
            if let menu = menu {
                nameLabel.text = menu.name
            }
        }
    }
    
    /// outlets
    @IBOutlet weak var nameLabel: UILabel!

    /**
     Configure the cell
     
     - parameter menu: menu
     */
    func configure(menu: Menu) {
        nameLabel.text = menu.name
    }

}

//
//  SectionHeaderTableViewCell.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/1/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 * Menu section header
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class SectionHeaderTableViewCell: UITableViewCell {
    /// section
    var section : MenuSection? {
        didSet {
            if let section = section {
                nameLabel.text = section.name
                
                if !section.name.isEmpty {
                    let lineColor = UIColor.darkBlueColor().CGColor
                    let width = UIScreen.mainScreen().bounds.width
                    // Add the top line
                    let bottomLine = CALayer()
                    bottomLine.frame = CGRectMake(0, 1, width, 1)
                    bottomLine.backgroundColor = lineColor
                    self.layer.addSublayer(bottomLine)
                    
                    // Add the bottom line
                    let topLine = CALayer()
                    topLine.frame = CGRectMake(0, 29, width, 1)
                    topLine.backgroundColor = lineColor
                    self.layer.addSublayer(topLine)
                }
            }
        }
    }
    
    /// outlets
    @IBOutlet weak var nameLabel: UILabel!
    
}

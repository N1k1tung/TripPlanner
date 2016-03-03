//
//  TripsViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/28/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 * Trips list screen
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class TripsViewController: ListViewController {
    
    /**
     creates firebase object store
     
     - returns: object store
     */
    override func createStore() -> ObjectStore {
        return TripsDataStore()
    }
    
    /**
     initializes filters
     */
    override func initFilters() {
        let all: Filter = (title: "All".localized, image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
            return objs
        })
        let started: Filter = (title: "Started".localized, image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
            return objs.filter { ($0 as! Trip).status == "Started".localized }
        })
        let ongoing: Filter = (title: "Ongoing".localized, image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
            return objs.filter { ($0 as! Trip).status != "Started".localized && ($0 as! Trip).status != "Finished".localized }
        })
        let finished: Filter = (title: "Finished".localized, image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
            return objs.filter { ($0 as! Trip).status == "Finished".localized }
        })
        filters = [all, started, ongoing, finished]
        currentFilter = all
        searchFilter = (title: "", image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
            return objs.filter { (($0 as! Trip).destination?.0 ?? "").contains(self.searchBar.text!, caseSensitive: false) }
        })
    }
    
    /**
     cell configuration
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.getCell(indexPath, ofClass: TripCell.self)
        let trip = objects[indexPath.row]
        cell.configure(trip as! Trip)
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? TripDetailsViewController {
            vc.dataStore = dataStore as! TripsDataStore
            if let indexPath = tableView.indexPathForSelectedRow {
                // edit
                vc.trip = objects[indexPath.row] as! Trip
                vc.onSave = { (trip) in
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            } else
            {
                // create already handled
            }
        }
    }

}
//
//  TripsViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/28/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import PKHUD

/**
 * Trips list screen
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class TripsViewController: UIViewController {

    /// data store
    let dataStore = TripsDataStore()
    
    /// trips
    var allTrips: [Trip] = [] {
        didSet {
            reloadRows()
        }
    }
    
    /// skips full table reload if set
    var animatedReload = false
    
    /// displayed trips
    var trips: [Trip] = [] {
        didSet {
            if !animatedReload {
                tableView?.reloadData()
            }
        }
    }
    
    /// outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    /// is searching or not
    var isSearching = false {
        didSet {
            reloadRows()
        }
    }
    
    // filters
    var filters: [Filter] = []
    // selected
    var currentFilter: Filter! {
        didSet {
            reloadRows()
        }
    }

    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initFilters()
        addMenuButton()
        dataStore.onChange = {
            self.allTrips = self.dataStore.trips
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    /**
     initializes filters
     */
    func initFilters() {
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
    }
    
    /**
     filter tap handler
     
     - parameter sender: the button
     */
    @IBAction func filterTapped(sender: UIBarButtonItem) {
        UIPopoverController.showPopover("Filter".localized, filters: filters, selectedFilter: currentFilter, fromBarButtonItem: sender) { (selected) -> Void in
            self.currentFilter = selected
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? TripDetailsViewController {
            vc.dataStore = dataStore
            if let indexPath = tableView.indexPathForSelectedRow {
                // edit
                vc.trip = trips[indexPath.row]
                vc.onSave = { (trip) in
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            } else
            {
                // create already handled
            }
        }
    }
    
    /**
     updates displayed rows
     */
    func reloadRows() {
        var trips = allTrips
        if isSearching && (searchBar.text ?? "").notEmpty() {
            trips = trips.filter { ($0.destination?.0 ?? "").contains(searchBar.text!, caseSensitive: false) }
        }
        trips = currentFilter.filter(trips) as! [Trip]
        self.trips = trips
    }

}

// MARK: - UISearchBarDelegate
extension TripsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        isSearching = true
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        reloadRows()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearching = false
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TripsViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.getCell(indexPath, ofClass: TripCell.self)
        let trip = trips[indexPath.row]
        cell.configure(trip)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("add", sender: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // delete trip
            let trip = trips[indexPath.row]
            if let key = trip.key {
                HUD.show(.Progress)
                dataStore.removeSeat(key, callback: { (error) -> Void in
                    HUD.hide(afterDelay: 0, completion: nil)
                    if let error = error {
                        self.showErrorAlert(error.localizedDescription.stripCodeInfo)
                    } else
                    {
                        // delete row with animation
                        self.animatedReload = true
                        self.allTrips.removeAtIndex(self.allTrips.indexOf(trip)!)
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        self.animatedReload = false
                    }
                })
            } else
            {
                print("WARNING: Deleting unsynced trip!")
            }
        }
    }
    
}
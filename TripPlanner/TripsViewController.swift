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
class TripsViewController: UIViewController {

    /// trips
    var allTrips: [Trip] = [] {
        didSet {
            trips = allTrips
        }
    }
    
    /// displayed trips
    var trips: [Trip] = [] {
        didSet {
            tableView?.reloadData()
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
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addMenuButton()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    /**
     filter tap handler
     
     - parameter sender: the button
     */
    @IBAction func filterTapped(sender: AnyObject) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? TripDetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                // edit
                vc.trip = trips[indexPath.row]
                vc.onSave = { (trip) in
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            } else
            {
                // create
                vc.onSave = { (trip) in
                    self.allTrips.append(trip)
                }
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
        self.performSegueWithIdentifier("edit", sender: nil)
    }
    
}
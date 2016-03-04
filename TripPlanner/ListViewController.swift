//
//  ListViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/3/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import PKHUD

/**
 * Base list controller
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class ListViewController: UIViewController {
    
    /// outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    /// data store
    var dataStore: ObjectStore!
    
    /// trips
    var allObjects: [StoredObject] = [] {
        didSet {
            reloadRows()
        }
    }
    
    /// skips full table reload if set
    var animatedReload = false
    
    /// displayed trips
    var objects: [StoredObject] = [] {
        didSet {
            if !animatedReload {
                tableView?.reloadData()
            }
        }
    }

    
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
    // search filter
    var searchFilter: Filter!
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initFilters()
        addMenuButton()
        dataStore = createStore()
        dataStore.onChange = {
            self.allObjects = self.dataStore.objects
        }
    }

    /**
     view will appear
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    /**
     updates displayed rows
     */
    func reloadRows() {
        var objects = allObjects
        if isSearching && (searchBar.text ?? "").notEmpty() {
            objects = searchFilter.filter(objects) as! [StoredObject]
        }
        objects = currentFilter.filter(objects) as! [StoredObject]
        self.objects = objects
    }
    
    // MARK: - actions
    
    /**
     filter tap handler
     
     - parameter sender: the button
     */
    @IBAction func filterTapped(sender: UIBarButtonItem) {
        UIPopoverController.showPopover("Filter".localized, filters: filters, selectedFilter: currentFilter, fromBarButtonItem: sender) { (selected) -> Void in
            self.currentFilter = selected
        }
    }
    
    // MARK: - overrides
    
    /**
     initializes filters
     */
    func initFilters() {
        print("override \(__FUNCTION__)")
    }
    
    /**
     creates firebase object store
     
     - returns: object store
     */
    func createStore() -> ObjectStore {
        print("override \(__FUNCTION__)")
        return ObjectStore()
    }

    /**
     cell configuration
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("override \(__FUNCTION__)")
        return UITableViewCell()
    }

}

// MARK: - UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    
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
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("add", sender: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // delete object
            let object = objects[indexPath.row]
            if let key = object.key {
                HUD.show(.Progress)
                dataStore.removeObject(key, callback: { (error) -> Void in
                    HUD.hide(afterDelay: 0, completion: nil)
                    if let error = error {
                        self.showErrorAlert(error.localizedDescription.stripCodeInfo)
                    } else
                    {
                        // delete row with animation
                        self.animatedReload = true
                        self.allObjects.removeAtIndex(self.allObjects.indexOf(object)!)
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        self.animatedReload = false
                    }
                })
            } else
            {
                print("WARNING: Deleting unsynced object!")
            }
        }
    }
    
}
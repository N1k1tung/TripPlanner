//
//  UsersViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/3/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 * Users list screen
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class UsersViewController: ListViewController {

    /**
     creates firebase object store
     
     - returns: object store
     */
    override func createStore() -> ObjectStore {
        return UsersDataStore()
    }

    /**
     initializes filters
     */
    override func initFilters() {
        let all: Filter = (title: "All".localized, image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
            return objs
        })
        let started: Filter = (title: UserRole.User.rawValue.localized, image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
            return objs.filter { ($0 as! User).role == .User }
        })
        let ongoing: Filter = (title: UserRole.Manager.rawValue.localized, image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
            return objs.filter { ($0 as! User).role == .Manager }
        })
        let finished: Filter = (title: UserRole.Admin.rawValue.localized, image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
            return objs.filter { ($0 as! User).role == .Admin }
        })
        filters = [all, started, ongoing, finished]
        currentFilter = all
        searchFilter = (title: "", image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
            return objs.filter { ($0 as! User).name.contains(self.searchBar.text!, caseSensitive: false) || ($0 as! User).email.contains(self.searchBar.text!, caseSensitive: false) }
        })
    }
    
    /**
     cell configuration
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.getCell(indexPath, ofClass: UserCell.self)
        let user = objects[indexPath.row] as! User
        cell.configure(user)
        cell.accessoryType = user.key == LoginDataStore.sharedInstance.uid ? .Checkmark : .None
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? UserDetailsViewController {
            vc.dataStore = dataStore as! UsersDataStore
            if let indexPath = tableView.indexPathForSelectedRow {
                // edit
                vc.user = objects[indexPath.row] as! User
                vc.onSave = { (user) in
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            } else
            {
                // create already handled
            }
        }
    }

}

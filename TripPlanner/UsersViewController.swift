//
//  UsersViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/3/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import PKHUD

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
        let all = Filter(title: "All".localized, image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
            return objs
        })
        let started = Filter(title: UserRole.User.rawValue.localized, image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
            return objs.filter { ($0 as! User).role == .User }
        })
        let ongoing = Filter(title: UserRole.Manager.rawValue.localized, image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
            return objs.filter { ($0 as! User).role == .Manager }
        })
        let finished = Filter(title: UserRole.Admin.rawValue.localized, image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
            return objs.filter { ($0 as! User).role == .Admin }
        })
        filters = [all, started, ongoing, finished]
        currentFilter = all
        searchFilter = Filter(title: "", image: nil, filter: { (objs: [AnyObject]) -> [AnyObject] in
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
    
    // allow delete for some rows
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        let user = objects[indexPath.row] as! User
        return user.key != LoginDataStore.sharedInstance.userInfo.key && // can't delete self
            (user.role != .Admin || LoginDataStore.sharedInstance.userInfo.role == .Admin) ? .Delete : .None
    }
    
    // delete row
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // removing user requires password: https://github.com/firebase/angularfire/issues/530
            let alert = UIAlertController(title: "", message: "Enter user's password".localized, preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
                textfield.secureTextEntry = true
                textfield.placeholder = "Password".localized
            })
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: { [unowned alert] (_) -> Void in
                if let text = alert.textFields?.first?.text where text.notEmpty() {
                    self.deleteUserAtIndexPath(indexPath, password: text)
                } else
                {
                    self.showErrorAlert("Password cannot be empty".localized)
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /**
     deletes user at index path
     
     - parameter indexPath: indexPath
     - parameter password:  password
     */
    func deleteUserAtIndexPath(indexPath: NSIndexPath, password: String) {
        // delete object
        let user = objects[indexPath.row] as! User
        if let _ = user.key {
            HUD.show(.Progress)
            (dataStore as! UsersDataStore).removeUser(user, password: password, callback: { (error) -> Void in
                HUD.hide(afterDelay: 0, completion: nil)
                if let error = error {
                    self.showErrorAlert(error.localizedDescription.stripCodeInfo)
                } else
                {
                    // delete row with animation
                    self.animatedReload = true
                    self.allObjects.removeAtIndex(self.allObjects.indexOf(user)!)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    self.animatedReload = false
                }
            })
        } else
        {
            print("WARNING: Deleting unsynced object!")
        }
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
                    // reload all since the selected user may have been changed
                    self.tableView.reloadData()
                }
            } else
            {
                // create already handled
            }
        }
    }

}

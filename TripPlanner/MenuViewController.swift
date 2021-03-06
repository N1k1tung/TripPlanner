//
//  MenuViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/1/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit


/**
Menu items
*/
enum MenuItem {
    case Trips
    case MonthPlan
    case Users
    case Logout
}

/**
menu structure
*/
struct Menu {
    /// item
    let item: MenuItem
    /// item name
    let name: String
    /// controller name
    let controllerName: String
    /// storyboard name
    var storyboardName: String?
    
    init(item: MenuItem, name: String, controllerName: String, storyboardName: String? = nil) {
        self.item = item
        self.name = name
        self.controllerName = controllerName
        self.storyboardName = storyboardName
    }
}

/**
menu section
*/
struct MenuSection  {
    /// name
    var name: String
    /// items
    let items: [MenuItem]
}


/**
 * menu view controller
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class MenuViewController: UIViewController {

    /// table view
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    /// connection status
    var offline = false {
        didSet {
            tableView?.reloadData()
        }
    }

    /// the menus
    let menus: [MenuItem: Menu] = [
        .Trips				: Menu(item: .Trips, name: "Trips".localized, controllerName: String.stringFromClass(TripsViewController.self)),
        .MonthPlan          : Menu(item: .MonthPlan, name: "Month plan".localized, controllerName: String.stringFromClass(MonthPlanViewController.self)),
        .Users              : Menu(item: .Users, name: "Users".localized, controllerName: String.stringFromClass(UsersViewController.self), storyboardName: "Users"),
        .Logout             : Menu(item: .Logout, name: "Logout".localized, controllerName: "")
    ]

    /// the sections
    var sections: [MenuSection] = []

    /**
    View did load
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .veryLightGray()
        self.view.backgroundColor = .veryLightGray()
        
        let userInfo = LoginDataStore.sharedInstance.userInfo
        usernameLabel.text = userInfo.name
        switch userInfo.role {
        case .User:
            sections = [
                MenuSection(name: "Trips".localized.uppercaseString, items: [.Trips, .MonthPlan]),
                MenuSection(name: "Profile".localized.uppercaseString, items: [.Logout])
            ]
        case .Manager:
            sections = [
                MenuSection(name: "Trips".localized.uppercaseString, items: [.Trips, .MonthPlan]),
                MenuSection(name: "Users".localized.uppercaseString, items: [.Users]),
                MenuSection(name: "Profile".localized.uppercaseString, items: [.Logout])
            ]
        case .Admin:
            sections = [
                MenuSection(name: "Trips".localized.uppercaseString, items: [.Trips, .MonthPlan]),
                MenuSection(name: "Users".localized.uppercaseString, items: [.Users]),
                MenuSection(name: "Profile".localized.uppercaseString, items: [.Logout])
            ]
        }
        
    }

    /**
     Create content controller at index.
     
     - parameter index: The index
     
     - returns: the controller.
     */
    func createContentControllerAtIndex(index: NSIndexPath) -> UIViewController? {
        return createContentControllerForItem(self.sections[index.section].items[index.row])
    }
    
    /**
     Create controller for item.
     
     - parameter item: The item
     
     - returns: the controller.
     */
    func createContentControllerForItem(item: MenuItem) -> UIViewController? {
        if let menu = self.menus[item] {
            if let storyboardName = menu.storyboardName {
                let controller = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(menu.controllerName)
                return controller
            } else {
                let controller = storyboard?.instantiateViewControllerWithIdentifier(menu.controllerName)
                if let controller = controller {
                    return controller
                }
            }
        }
        return nil
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MenuViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.getCell(indexPath, ofClass: MenuTableViewCell.self)
        let menu = self.menus[self.sections[indexPath.section].items[indexPath.row]]
        cell.menu = menu
        cell.contentView.backgroundColor = tableView.backgroundColor
        cell.backgroundColor = tableView.backgroundColor
        return cell
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCellWithIdentifier("SectionHeaderTableViewCell") as? SectionHeaderTableViewCell
        header?.section = self.sections[section]
        header?.contentView.backgroundColor = tableView.backgroundColor
        header?.backgroundColor = tableView.backgroundColor

        return header
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let menu = self.menus[self.sections[indexPath.section].items[indexPath.row]]
        
        if menu?.item == .Logout {
            self.slideMenuController?.confirmLogout()
        } else if !menu!.controllerName.isEmpty {
            if let controller = createContentControllerAtIndex(indexPath) {
                self.slideMenuController?.setContentViewController(controller)
            }
        }
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
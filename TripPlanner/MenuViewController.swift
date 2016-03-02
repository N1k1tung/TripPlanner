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
        .Users              : Menu(item: .Users, name: "Users".localized, controllerName: String.stringFromClass(TripsViewController.self)),
        .Logout             : Menu(item: .Logout, name: "Logout".localized, controllerName: "")
    ]

    /// the sections
    let sections: [MenuSection] = [MenuSection(name: "Trips".localized.uppercaseString, items: [.Trips]),
        MenuSection(name: "Profile".localized.uppercaseString, items: [.Logout])]

    /**
    View did load
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .veryLightGray()
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
                return controller.wrapInNavigationController()
            } else {
                let controller = storyboard?.instantiateViewControllerWithIdentifier(menu.controllerName)
                if let controller = controller {
                    return controller.wrapInNavigationController()
                }
            }
        }
        return nil
    }
    
}

// MARK: - SlideMenuSideWidthDelegate
extension MenuViewController : SlideMenuSideWidthDelegate
{
    /**
    the width of the left side menu

    - returns: the width.
    */
    func slideLeftMenuSideWidth() -> CGFloat {
        return tableView.bounds.width
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
        header!.section = self.sections[section]
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
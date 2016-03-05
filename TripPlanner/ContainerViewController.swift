//
//  ContainerViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/1/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/// root container
var RootContainerController: ContainerViewController?

/**
 * Container screen
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class ContainerViewController: UIViewController {

    /// home menu
    var slideController: SlideMenuViewController?
    var menu: MenuViewController?
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menu = create(MenuViewController)
        let defaultVC = create(TripsViewController)!.wrapInNavigationController()
        slideController = SlideMenuViewController(
            leftSideController: menu!,
            defaultContent: defaultVC
        )
        loadChildController(slideController!, inContentView: self.view)
        
        // update global ref
        RootContainerController = self
    }
    
    /**
     Loads popover view controller
     
     - parameter viewController: the popover view controller
     */
    func showViewControllerAsPopover(viewController: UIViewController) {
        loadChildController(viewController, inContentView: self.view)
    }

}

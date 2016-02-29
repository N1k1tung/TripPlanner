//
//  TripsDataStore.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/28/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import Firebase

/**
 * Firebase wrapper for Trips
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class TripsDataStore {

    /// singleton
    static let sharedInstance = TripsDataStore()
    
    /// db ref
    private let ref: Firebase
    
    /**
     initializer
     */
    init() {
        let firebaseURL = Configuration.firebaseURL()
        let uid = LoginDataStore.sharedInstance.uid
        ref = Firebase(url:"\(firebaseURL)/users/\(uid)/trips")
    }
    
}

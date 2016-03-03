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
class TripsDataStore: ObjectStore {

    /// trips
    var trips: [Trip] {
        return objects as! [Trip]
    }
    
    /**
     ref constructor
     
     - returns: firebase ref
     */
    override func createRef() -> Firebase {
        let firebaseURL = Configuration.firebaseURL()
        let uid = LoginDataStore.sharedInstance.uid
        return Firebase(url:"\(firebaseURL)/trips/\(uid)")
    }

    /**
     object constructor
     
     - parameter dictionary: data dictionary
     
     - returns: stored object
     */
    override func createObject(dictionary: NSDictionary) -> StoredObject {
        return Trip(dictionary: dictionary)
    }
}

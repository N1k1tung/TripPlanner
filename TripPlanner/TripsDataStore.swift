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

    /// db ref
    private let ref: Firebase
    
    /// trips data
    var trips: [Trip] = []
    
    /// change handler
    var onChange: (() -> Void)?
    
    /**
     initializer
     */
    init() {
        let firebaseURL = Configuration.firebaseURL()
        let uid = LoginDataStore.sharedInstance.uid
        ref = Firebase(url:"\(firebaseURL)/users/\(uid)/trips")
        
        // Retrieve new trip as they are added to Firebase
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            let dic = NSMutableDictionary(dictionary: snapshot.value as! NSDictionary)
            dic.setValue(snapshot.key, forKey: "key")   // add key to dictionary for remove
            self.trips.append(Trip(dictionary: dic))
            self.onChange?()
        })
        
        // Update trips as they are updated on Firebase
        ref.observeEventType(.ChildChanged, withBlock: { snapshot in
            let dic = NSMutableDictionary(dictionary: snapshot.value as! NSDictionary)
            dic.setValue(snapshot.key, forKey: "key")   // add key to dictionary for remove
            self.trips[self.trips.indexOf({ $0.key == snapshot.key })!] = Trip(dictionary: dic)
        })
        
        
        // Retrieve removed seat as they are removed from Firebase
        ref.observeEventType(.ChildRemoved, withBlock: { snapshot in
            self.trips.removeAtIndex(self.trips.indexOf({ $0.key == snapshot.key })!)
        })
    }
    
     /**
     Upsert trip to firebase
     
     - parameter trip:     trip
     - parameter callback: callback
     */
    func addTrip(trip: Trip, callback: ((NSError!) -> Void)?) {
        let tripRef = trip.key != nil ? ref.childByAppendingPath(trip.key!) : ref.childByAutoId()
        let tripValue = trip.toDictionary()
        tripRef.setValue(tripValue, withCompletionBlock: { (error: NSError!, ref: Firebase!) -> Void in
            callback?(error)
        })
    }
    
     /**
     Remove trip from firebase
     
     - parameter key:      key of trip
     - parameter callback: callback
     */
    func removeSeat(key: String, callback: ((NSError!) -> Void)?) {
        ref.childByAppendingPath(key).removeValueWithCompletionBlock { (error: NSError!, ref: Firebase!) -> Void in
            callback?(error)
        }
    }

}

//
//  ObjectStore.swift
//  objectPlanner
//
//  Created by Nikita Rodin on 3/3/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import Firebase

/**
 * Base class for read/write Firebase store
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class ObjectStore {

    /// db ref
    private var ref: Firebase!
    
    /// objects
    var objects: [StoredObject] = []
    
    /// change handler
    var onChange: (() -> Void)?
    
    /**
     ref constructor
     
     - returns: firebase ref
     */
    func createRef() -> Firebase {
        let firebaseURL = Configuration.firebaseURL()
        return Firebase(url:"\(firebaseURL)")
    }
    
    /**
     object constructor
     
     - parameter dictionary: data dictionary
     
     - returns: stored object
     */
    func createObject(dictionary: NSDictionary) -> StoredObject {
        return StoredObject(dictionary: dictionary)
    }
    
    /**
     initializer
     */
    init() {
        ref = createRef()
        
        // Retrieve new objects as they are added to Firebase
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            let dic = NSMutableDictionary(dictionary: snapshot.value as! NSDictionary)
            dic.setValue(snapshot.key, forKey: "key")   // add key to dictionary for remove
            self.objects.append(self.createObject(dic))
            self.onChange?()
        })
        
        // Update objects as they are updated on Firebase
        ref.observeEventType(.ChildChanged, withBlock: { snapshot in
            let dic = NSMutableDictionary(dictionary: snapshot.value as! NSDictionary)
            dic.setValue(snapshot.key, forKey: "key")   // add key to dictionary for remove
            self.objects[self.objects.indexOf({ $0.key == snapshot.key })!] = self.createObject(dic)
        })
        
        
        // Retrieve removed objects as they are removed from Firebase
        ref.observeEventType(.ChildRemoved, withBlock: { snapshot in
            self.objects.removeAtIndex(self.objects.indexOf({ $0.key == snapshot.key })!)
        })
    }
    
    /**
     Upsert object to firebase
     
     - parameter object:     object
     - parameter callback: callback
     */
    func upsertObject(object: StoredObject, callback: ((NSError?) -> Void)?) {
        let objRef = object.key != nil ? ref.childByAppendingPath(object.key!) : ref.childByAutoId()
        let objValue = object.toDictionary()
        objRef.setValue(objValue, withCompletionBlock: { (error: NSError!, ref: Firebase!) -> Void in
            callback?(error)
        })
    }
    
    /**
     Remove object from firebase
     
     - parameter key:      object key
     - parameter callback: callback
     */
    func removeObject(key: String, callback: ((NSError?) -> Void)?) {
        ref.childByAppendingPath(key).removeValueWithCompletionBlock { (error: NSError!, ref: Firebase!) -> Void in
            callback?(error)
        }
    }
    
}

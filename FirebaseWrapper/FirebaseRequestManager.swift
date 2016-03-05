//
//  FirebaseRequestManager.swift
//  FirebaseWrapper
//
//  Created by Nikita Rodin on 3/5/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ReachabilitySwift

// Note: callbacks will be performed on main thread
/// success handler type
public typealias FirebaseRequestSuccessHandler = (JSON) -> Void

/// failure handler type
public typealias FirebaseRequestFailureHandler = (NSError) -> Void

/**
* Singleton wrapper for Firebase requests
*
* :author: Nikita Rodin
* :version: 1.0
*/
public class FirebaseRequestManager {
   
    /// errors domain
    public static let kErrorDomain = "FIREBASE_REQUEST_ERROR"
    
    // MARK: Singleton
    public class func sharedInstance() -> FirebaseRequestManager {
        struct Static {
            static var once: dispatch_once_t = 0
            static var instance: FirebaseRequestManager! = nil
        }
        dispatch_once(&Static.once) {
            Static.instance = FirebaseRequestManager()
        }
        return Static.instance
    }
    
    /// reachability
    public class var isReachable: Bool {
        return (try? Reachability.reachabilityForInternetConnection())?.isReachable() ?? false
    }

    // MARK: - interface

    /**
    performs GET request on /users
    
    - parameter success success handler
    - parameter failure failure handler
    */
    public func getUsers(success: FirebaseRequestSuccessHandler?, failure: FirebaseRequestFailureHandler?) {
        self.performRequest("/users", success: success, failure: failure)
    }
    
    /**
    performs GET request on /users/<uid>
    
     - parameter uid user id
     - parameter success success handler
     - parameter failure failure handler
    */
    public func getUserInfo(uid: String, success: FirebaseRequestSuccessHandler?, failure: FirebaseRequestFailureHandler?) {
        if !ValidationUtils.validateId(uid, failure) {
            return
        }
        self.performRequest("/users/\(uid)", success: success, failure: failure)
    }
    
    /**
     performs PATCH request on /users/<uid>
     
     - parameter uid user id
     - parameter data user data
     - parameter success success handler
     - parameter failure failure handler
     */
    public func updateUserInfo(uid: String, data: User, success: FirebaseRequestSuccessHandler?, failure: FirebaseRequestFailureHandler?) {
        if !ValidationUtils.validateId(uid, failure) || !ValidationUtils.validateUser(data, failure) {
            return
        }
        self.performRequest("/users/\(uid)", method: .PATCH, parameters: data.toDictionary(), success: success, failure: failure)
    }
    
    /**
     performs POST request on /users
     
     - parameter data user data
     - parameter success success handler
     - parameter failure failure handler
     */
    public func createUserInfo(data: User, success: FirebaseRequestSuccessHandler?, failure: FirebaseRequestFailureHandler?) {
        if !ValidationUtils.validateUser(data, failure) {
            return
        }
        self.performRequest("/users", method: .POST, parameters: data.toDictionary(), success: success, failure: failure)
    }
    
    /**
     performs DELETE request on /users/<uid>
     
     - parameter uid user id
     - parameter data user data
     - parameter success success handler
     - parameter failure failure handler
     */
    public func deleteUserInfo(uid: String, success: FirebaseRequestSuccessHandler?, failure: FirebaseRequestFailureHandler?) {
        if !ValidationUtils.validateId(uid, failure) {
            return
        }
        self.performRequest("/users/\(uid)", method: .DELETE, success: success, failure: failure)
    }
    
    /**
     performs GET request on /trips/<uid>
     
     - parameter uid user id
     - parameter success success handler
     - parameter failure failure handler
     */
    public func getUserTrips(uid: String, success: FirebaseRequestSuccessHandler?, failure: FirebaseRequestFailureHandler?) {
        if !ValidationUtils.validateId(uid, failure) {
            return
        }
        self.performRequest("/trips/\(uid)", success: success, failure: failure)
    }
    
    /**
     performs GET request on /trips/<uid>/<tripID>
     
     - parameter uid user id
     - parameter tripID trip id
     - parameter success success handler
     - parameter failure failure handler
     */
    public func getUserTrip(uid: String, withID tripID: String, success: FirebaseRequestSuccessHandler?, failure: FirebaseRequestFailureHandler?) {
        if !ValidationUtils.validateIds([uid, tripID], failure) {
            return
        }
        self.performRequest("/trips/\(uid)/\(tripID)", success: success, failure: failure)
    }
    
    /**
     performs PATCH request on /trips/<uid>/<tripID>
     
     - parameter uid user id
     - parameter tripID trip id
     - parameter data trip data
     - parameter success success handler
     - parameter failure failure handler
     */
    public func updateUserTrip(uid: String, withID tripID: String, data: Trip, success: FirebaseRequestSuccessHandler?, failure: FirebaseRequestFailureHandler?) {
        if !ValidationUtils.validateIds([uid, tripID], failure) || !ValidationUtils.validateTrip(data, failure) {
            return
        }
        self.performRequest("/trips/\(uid)/\(tripID)", method: .PATCH, parameters: data.toDictionary(), success: success, failure: failure)
    }
    
    /**
     performs POST request on /trips/<uid>
     
     - parameter uid user id
     - parameter data trip data
     - parameter success success handler
     - parameter failure failure handler
     */
    public func createUserTrip(uid: String, data: Trip, success: FirebaseRequestSuccessHandler?, failure: FirebaseRequestFailureHandler?) {
        if !ValidationUtils.validateId(uid, failure) || !ValidationUtils.validateTrip(data, failure) {
            return
        }
        self.performRequest("/trips/\(uid)/", method: .POST, parameters: data.toDictionary(), success: success, failure: failure)
    }
    
    /**
     performs DELETE request on /trips/<uid>/<tripID>
     
     - parameter uid user id
     - parameter tripID trip id
     - parameter data trip data
     - parameter success success handler
     - parameter failure failure handler
     */
    public func deleteUserTrip(uid: String, withID tripID: String, success: FirebaseRequestSuccessHandler?, failure: FirebaseRequestFailureHandler?) {
        if !ValidationUtils.validateIds([uid, tripID], failure) {
            return
        }
        self.performRequest("/trips/\(uid)/\(tripID)", method: .DELETE, success: success, failure: failure)
    }
    
    
    // MARK: - private
    
    /**
    creates full request path
    
    - parameter path subpath
    
    :returns: full request path
    */
    private func getFullPath(path: String) -> String {
        return Configuration.endpoint + path + ".json?auth=\(Configuration.firebaseAccessToken)"
    }
    
    /**
    performs request on specified path
    
    - parameter method method
    - parameter path subpath
    - parameter parameters parameters to put into body
    - parameter success success handler
    - parameter failure failure handler
    */
    private func performRequest(path: String, method: Alamofire.Method = .GET, parameters: [String : AnyObject]? = nil, success: FirebaseRequestSuccessHandler?, failure: FirebaseRequestFailureHandler?) {
        // reachability check
        if !FirebaseRequestManager.isReachable {
            let e = NSError.FirebaseError("No Internet connection")
            failure?(e)
            return
        }
        Logger.log(.Debug, "Performing \(method.rawValue) to \(path) with parameters: \(parameters)")
        // perform request
        Alamofire.request(method, getFullPath(path), parameters: parameters, headers: nil, encoding: method == .GET ? .URL : .JSON)
            .response { (request, response, data, error) -> Void in
                self.processJSONResponse(response, data: data, error: error, success: success, failure: failure)
        }
    }
    
    /**
    Processes server response
    
    - parameter response server response
    - parameter data     data, if any
    - parameter error    error, if any
    - parameter success success handler
    - parameter failure failure handler
    */
    private func processJSONResponse(response: NSHTTPURLResponse?, data: NSData?, error: NSError?, success: FirebaseRequestSuccessHandler?, failure: FirebaseRequestFailureHandler?) {
        // 200-204 are success codes
        if response?.statusCode >= 200 && response?.statusCode < 205 {
            var error: NSError?
            // try parsing to JSON
            if let data = data {
                let json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: &error)
                if let e = error {
                    Logger.log(.Error, e.localizedDescription)
                    dispatch_async(dispatch_get_main_queue()) {
                        failure?(e)
                    }
                } else
                {
                    Logger.log(.Info, json.description)
                    dispatch_async(dispatch_get_main_queue()) {
                        success?(json)
                    }
                }
            } else
            {
                Logger.log(.Error, "No data")
                dispatch_async(dispatch_get_main_queue()) {
                    failure?(NSError.FirebaseError("No data returned"))
                }
            }
        } else
        { // return received error, or if no error returned generate one with a status code
            if let d = data,
                let s = NSString(data: d, encoding: NSUTF8StringEncoding) {
                    Logger.log(.Error, s as String)
            } else
            {
                Logger.log(.Error, "Request failed")
            }
            dispatch_async(dispatch_get_main_queue()) {
                failure?(error != nil ? error! : NSError.FirebaseError("Request failed", code: response?.statusCode ?? 500))
            }
        }
    }
    
}

// MARK: - error helper
extension NSError {
    /**
     creates Firebase error
     
     - parameter message: error message
     - parameter code:    error code
     
     - returns: error
     */
    public class func FirebaseError(message: String, code: Int = -1) -> NSError {
        return NSError(domain: FirebaseRequestManager.kErrorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}

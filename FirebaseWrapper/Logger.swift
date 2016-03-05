//
//  Logger.swift
//  FirebaseWrapper
//
//  Created by Nikita Rodin on 3/5/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
* Logger class
*
* :author: Nikita Rodin
* :version: 1.0
*/
class Logger {
   
    /**
    Available log levels
    
    - None:  None
    - Error: Errors only
    - Info:  No debug log
    - Debug: All logs
    */
    enum LogLevel: Int {
        case None, Error, Info, Debug
        
        /**
        Formatted title
        
        :returns: formatted title
        */
        func title() -> String {
            switch self {
            case .None:
                return "[None]:\t"
            case .Error:
                return "[Error]:\t"
            case .Info:
                return "[Info]:\t"
            case .Debug:
                return "[Debug]:\t"
            }
        }
    }
    
    /// current log level
    static let loggerLevel = LogLevel(rawValue: Configuration.logLevel)!
    
    /**
    Logs message if current level is not less
    
    :param: level   message level
    :param: message text
    */
    class func log(level: LogLevel, _ message: String) {
        if Logger.loggerLevel.rawValue >= level.rawValue {
            print(level.title() + message)
        }
    }
    
}

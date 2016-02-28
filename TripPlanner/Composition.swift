//
//  Composition.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import Foundation

/**
*  function composition operator
*/
infix operator .. { associativity right }

/// Binary function composition with a constant
public func .. <T, U, V>(f: (U, T) -> V, g: T) -> U -> V {
    return { f($0, g) }
}
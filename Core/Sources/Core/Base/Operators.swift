//
//  Operators.swift
//  TicTacToe
//
//  Created by Andrew Galushka on 4/27/21.
//  Copyright © 2021 Andrew Galushka. All rights reserved.
//

import Foundation

public func | <T>(_ object: T, block: (inout T) -> Void) -> T {
    modified(object, block: block)
}

func modified<T>(_ object: T, block: (inout T) -> Void) -> T {
    var newObject = object
    block(&newObject)
    return newObject
}

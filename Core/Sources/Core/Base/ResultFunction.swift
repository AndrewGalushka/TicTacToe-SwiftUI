//
//  ResultFunction.swift
//  TicTacToe
//
//  Created by Andrew Galushka on 4/27/21.
//  Copyright © 2021 Andrew Galushka. All rights reserved.
//

import Foundation

/// This is simple apply like function.
/// It main goal to avoid code like this:
///
/// ```
/// let x = { ... }()
/// ```
///
/// Instead you can write:
/// ```
/// let x = result { ... }
/// ```
public func result<Result>(from block: () -> Result) -> Result {
    return block()
}

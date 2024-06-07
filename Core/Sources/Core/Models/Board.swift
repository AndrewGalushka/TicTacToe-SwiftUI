//
//  Board.swift
//  
//
//  Created by Andrii Halushka on 13.03.2023.
//

import Foundation

public struct Board: Equatable {
    public typealias Element = SquareState
    
    public internal(set) var matrix = [[SquareState]]()
    let size = 3
    
    init() {
        self.matrix = Array(repeating: Array(repeating: SquareState.empty, count: size), count: size)
    }
    
    public enum SquareState: Equatable {
        case empty
        case filled_x
        case filled_0
    }
}

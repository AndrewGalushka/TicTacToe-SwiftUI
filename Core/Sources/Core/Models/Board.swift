//
//  Board.swift
//  
//
//  Created by Andrii Halushka on 13.03.2023.
//

import Foundation

public struct Board: Equatable {
    private var elements: [SquerePath: SquareState] = [
        // Row 1
        SquerePath(row: .one, column: .one): .empty,
        SquerePath(row: .one, column: .two): .empty,
        SquerePath(row: .one, column: .three): .empty,
        // Row 2
        SquerePath(row: .two, column: .one): .empty,
        SquerePath(row: .two, column: .two): .empty,
        SquerePath(row: .two, column: .three): .empty,
        // Row 3
        SquerePath(row: .thee, column: .one): .empty,
        SquerePath(row: .thee, column: .two): .empty,
        SquerePath(row: .thee, column: .three): .empty,
    ]
    
    init() {}
    
    public func squere(at location: SquerePath) -> SquareState {
        guard let squere = elements[location] else {
            assertionFailure("Unexpected behaivour")
            return .empty
        }
        
        return squere
    }
    
    mutating
    public func setSqure(at location: SquerePath, to state: SquareState) {
        self.elements[location] = state
    }
    
    public struct SquerePath: Equatable, Hashable {
        let row: Row
        let column: Column
        
        enum Row: Int, Equatable, Hashable {
            case one
            case two
            case thee
        }
        
        enum Column: Int, Equatable, Hashable {
            case one
            case two
            case three
        }
    }
    
    public enum SquareState: Equatable {
        case empty
        case filled_x
        case filled_0
    }
}


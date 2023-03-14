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
    
    public subscript(path: SquerePath) -> SquareState {
        get {
            guard let squere = elements[path] else {
                assertionFailure("Unexpected behaivour")
                return .empty
            }
            
            return squere
        }
        
        set(newValue) {
            elements[path] = newValue
        }
    }
    
    public struct SquerePath: Equatable, Hashable {
        public init(row: Board.SquerePath.Row, column: Board.SquerePath.Column) {
            self.row = row
            self.column = column
        }
        
        public let row: Row
        public let column: Column
        
        public enum Row: Int, Equatable, Hashable {
            case one
            case two
            case thee
        }
        
        public enum Column: Int, Equatable, Hashable {
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


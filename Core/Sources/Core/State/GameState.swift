//
//  File.swift
//  
//
//  Created by Andrii Halushka on 13.03.2023.
//

import Foundation

public enum GameState: Equatable {
    case idle
    case running(ActiveGame)
    case ended(Board, Winner)
    
    public struct ActiveGame: Equatable {
        public fileprivate(set) var board: Board
        public fileprivate(set) var turnOwner: Player
        
        static var initial: ActiveGame {
            return .init(board: Board(), turnOwner: .initial)
        }
    }
    
    public enum Player: Equatable {
        case player_X
        case player_O
        
        mutating func toggle() {
            switch self {
            case .player_X:
                self = .player_O
            case .player_O:
                self = .player_X
            }
        }
        
        static var initial: Player {
            .player_X
        }
    }
    
    public enum Winner: Equatable {
        case player(Player, path: WinningPath)
        case draw
    }
    
    public struct WinningPath: Equatable {
        public let start: Location
        public let end: Location
        
        public struct Location: Equatable {
            public let row: Int
            public let column: Int
        }
    }
    
    public static var intiail: GameState {
        GameState.idle
    }
}

public func reduce(_ state: GameState, with action: Action) -> GameState {
    switch action {
    case is Actions.GameConnector.Idle.Start:
        return .running(.initial)
    case is Actions.GameConnector.ActiveGame.Back:
        return .idle
    case is Actions.GameConnector.ActiveGame.Reset:
        switch state {
        case .idle:
            return state
        case .running, .ended:
            return .running(.initial)
        }
        
        
    case let action as Actions.GameConnector.ActiveGame.SquareTap:
        guard case let .running(activeGame) = state else {
            return state
        }
        guard action.x >= 0, action.y >= 0 else {
            assertionFailure()
            return state
        }
        guard action.x < activeGame.board.size, action.y < activeGame.board.size else {
            assertionFailure()
            return state
        }
                
        var activeGameMutated = activeGame
        
        if activeGameMutated.board.matrix[action.x][action.y] == .empty {
            activeGameMutated.board.matrix[action.x][action.y] = {
                switch activeGameMutated.turnOwner {
                case .player_O:
                    return .filled_0
                case .player_X:
                    return .filled_x
                }
            }()
            activeGameMutated.turnOwner.toggle()
        }
        
        if let result = checkForWinner(board: activeGameMutated.board) {
            return .ended(activeGameMutated.board, result)
        }
        
        return .running(activeGameMutated)
    default:
        return state
    }
}

func checkForWinner(board: Board) -> GameState.Winner? {
    let size = board.size
    let matrix = board.matrix

    // Check rows and columns
    for i in 0..<size {
        // Check row
        if matrix[i][0] != .empty, (1..<size).allSatisfy({ matrix[i][0] == matrix[i][$0] }) {
            let start = GameState.WinningPath.Location(row: i, column: 0)
            let end = GameState.WinningPath.Location(row: i, column: size - 1)
            return .player(
                matrix[i][0] == .filled_x ? .player_X : .player_O,
                path: GameState.WinningPath(start: start, end: end)
            )
        }
        
        // Check column
        if matrix[0][i] != .empty, (1..<size).allSatisfy({ matrix[$0][i] == matrix[0][i] }) {
            let start = GameState.WinningPath.Location(row: 0, column: i)
            let end = GameState.WinningPath.Location(row: size - 1, column: i)
            return .player(
                matrix[0][i] == .filled_x ? .player_X : .player_O,
                path: GameState.WinningPath(start: start, end: end)
            )
        }
    }
    
    // Check diagonals
    if matrix[0][0] != .empty, (1..<size).allSatisfy({ matrix[0][0] == matrix[$0][$0] }) {
        let start = GameState.WinningPath.Location(row: 0, column: 0)
        let end = GameState.WinningPath.Location(row: size - 1, column: size - 1)
        return .player(
            matrix[0][0] == .filled_x ? .player_X : .player_O,
            path: GameState.WinningPath(start: start, end: end)
        )
    }
    
    if matrix[size - 1][0] != .empty, (1..<size).allSatisfy({ matrix[size - 1][0] == matrix[size - 1 - $0][$0] }) {
        let start = GameState.WinningPath.Location(row: size - 1, column: 0)
        let end = GameState.WinningPath.Location(row: 0, column: size - 1)
        
        return .player(
            matrix[size - 1][0] == .filled_x ? .player_X : .player_O,
            path: GameState.WinningPath(start: start, end: end)
        )
    }
    
    // Check for draw
    if matrix.flatMap({ $0 }).allSatisfy({ $0 != .empty }) {
        return .draw
    }
    
    // No winner found
    return nil
}



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
    case ended(Winner)
    
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
        case player(Player)
        case draw
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
        
    case let action as Actions.GameConnector.ActiveGame.SquareTap:
        guard case let .running(activeGame) = state else {
            return state
        }
        
        var activeGameMutated = activeGame
        
        let path = Board.SquerePath(row: .init(rawValue: action.path.row.rawValue)!, column: .init(rawValue: action.path.column.rawValue)!)
        
        if activeGameMutated.board[path] == .empty {
            activeGameMutated.board[path] = {
                switch activeGameMutated.turnOwner {
                case .player_O:
                    return .filled_0
                case .player_X:
                    return .filled_x
                }
            }()
            activeGameMutated.turnOwner.toggle()
        }
        
        if let winner = checkForWinner(board: activeGameMutated.board) {
            return .ended(winner)
        }
        
        return .running(activeGameMutated)
    default:
        return state
    }
}

private func checkForWinner(board: Board) -> GameState.Winner? {
    return nil
}



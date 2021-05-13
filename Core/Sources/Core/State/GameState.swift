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
    case is Actions.GameConnector.Start:
        return .running(.initial)
    case is Actions.GameConnector.BackToMainMenu:
        return .idle
    default:
        return state
    }
}



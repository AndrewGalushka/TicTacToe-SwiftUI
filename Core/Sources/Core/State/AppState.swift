//
//  AppState.swift
//  TicTacToe
//
//  Created by Andrii Halushka on 13.05.2021.
//

import Foundation

public struct AppState: Equatable {
    public fileprivate(set) var game = GameState.intiail
    
    public static var initial: AppState {
        AppState()
    }
}

public func reduce(_ state: AppState, with action: Action) -> AppState {
    AppState(
        game: reduce(state.game, with: action)
    )
}

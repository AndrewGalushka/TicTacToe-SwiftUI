//
//  GameConnecotr.swift
//  TicTacToe
//
//  Created by Andrii Halushka on 13.03.2023.
//

import Core
import SwiftUI

struct GameConnecotor: StoreConnector {
    func map(state: AppState, store: EnvironmentStore) -> some View {
        func mapToViewState(_ state: GameState.ActiveGame) -> GameView.ActiveGame {
            func viewSquareState(forPath path: Core.Board.SquerePath) -> GameView.Board.SquareState {
                switch state.board[path] {
                case .empty:
                    return .empty(
                        onTap: store.bind(Actions.GameConnector.ActiveGame.SquareTap(path: path), id: "square_tap:\(path)")
                    )
                case .filled_0:
                    return .filled_0
                case .filled_x:
                    return .filled_x
                }
            }
            
            return GameView.ActiveGame(
                board: GameView.Board(
                    row1: GameView.Board.Row(
                        first: viewSquareState(forPath: .init(row: .one, column: .one)),
                        second: viewSquareState(forPath: .init(row: .one, column: .two)),
                        third: viewSquareState(forPath: .init(row: .one, column: .three))
                    ),
                    row2: GameView.Board.Row(
                        first: viewSquareState(forPath: .init(row: .two, column: .one)),
                        second: viewSquareState(forPath: .init(row: .two, column: .two)),
                        third: viewSquareState(forPath: .init(row: .two, column: .three))
                    ),
                    row3: GameView.Board.Row(
                        first: viewSquareState(forPath: .init(row: .thee, column: .one)),
                        second: viewSquareState(forPath: .init(row: .thee, column: .two)),
                        third: viewSquareState(forPath: .init(row: .thee, column: .three))
                    )
                ),
                turnOwner: {
                    switch state.turnOwner {
                    case .player_O:
                        return .player_O
                    case .player_X:
                        return .player_X
                    }
                }(),
                onBack: store.bind(Actions.GameConnector.ActiveGame.Back(), id: "back")
            )
        }
        
        return GameView(
            state: {
                switch state.game {
                case .idle:
                    return .idle(onStart: store.bind(Actions.GameConnector.Idle.Start(), id: "start"))
                case .running(let activeGame):
                    return .active(
                        mapToViewState(activeGame)
                    )
                case .ended(_):
                    return .idle(onStart: store.bind(Actions.GameConnector.Idle.Start(), id: "start"))
                }
            }()
        )
    }
}

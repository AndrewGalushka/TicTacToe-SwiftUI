//
//  GameConnecotr.swift
//  TicTacToe
//
//  Created by Andrii Halushka on 13.03.2023.
//

import Core
import SwiftUI

struct GameConnecotor: StoreConnector {
    @EnvironmentObject var store: EnvironmentStore
    
    func map(state: AppState, store: EnvironmentStore) -> some View {
        func mapToViewState(_ state: GameState.ActiveGame) -> GameView.ActiveGame {
            func viewSquareState(row: Int, column: Int) -> GameView.Board.SquareState {
                switch state.board.matrix[row][column] {
                case .empty:
                    return .empty(
                        onTap: store.bind(Actions.GameConnector.ActiveGame.SquareTap(x: row, y: column), id: "square_tap:\(row)|\(column)")
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
                        first: viewSquareState(row: 0, column: 0),
                        second: viewSquareState(row: 0, column: 1),
                        third: viewSquareState(row: 0, column: 2)
                    ),
                    row2: GameView.Board.Row(
                        first: viewSquareState(row: 1, column: 0),
                        second: viewSquareState(row: 1, column: 1),
                        third: viewSquareState(row: 1, column: 2)
                    ),
                    row3: GameView.Board.Row(
                        first: viewSquareState(row: 2, column: 0),
                        second: viewSquareState(row: 2, column: 1),
                        third: viewSquareState(row: 2, column: 2)
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
                reset: store.bind(Actions.GameConnector.ActiveGame.Reset(), id: "reset"),
                onBack: store.bind(Actions.GameConnector.ActiveGame.Back(), id: "back")
            )
        }
        
        return GameView(
            state: {
                switch state.game {
                case .idle:
                    return .idle(
                        onStart: store.bind(Actions.GameConnector.Idle.Start(), id: "start")
                    )
                case .running(let activeGame):
                    return .active(
                        mapToViewState(activeGame)
                    )
                case .ended(let board, let winner):
                    func convertToFinishedGameSquare(_ coreSquare: Board.SquareState) -> GameView.Board.SquareState {
                        switch coreSquare {
                        case .empty:
                            return .empty(onTap: .nop)
                        case .filled_0:
                            return .filled_0
                        case .filled_x:
                            return .filled_x
                        }
                    }
                    return .active(
                        GameView.ActiveGame(
                            board: GameView.Board(
                                row1: GameView.Board.Row(
                                    first: convertToFinishedGameSquare(board.matrix[0][0]),
                                    second: convertToFinishedGameSquare(board.matrix[0][1]),
                                    third: convertToFinishedGameSquare(board.matrix[0][2])
                                ),
                                row2:  GameView.Board.Row(
                                    first: convertToFinishedGameSquare(board.matrix[1][0]),
                                    second: convertToFinishedGameSquare(board.matrix[1][1]),
                                    third: convertToFinishedGameSquare(board.matrix[1][2])
                                ),
                                row3:  GameView.Board.Row(
                                    first: convertToFinishedGameSquare(board.matrix[2][0]),
                                    second: convertToFinishedGameSquare(board.matrix[2][1]),
                                    third: convertToFinishedGameSquare(board.matrix[2][2])
                                ),
                                crossLine:
                                    {
                                        switch winner {
                                        case .player(let winner, path: let winningPath):
                                            return winningPath.toViewCrossLine()
                                        case .draw:
                                            return nil
                                        }
                                    }()
                            ),
                            turnOwner: .initial, 
                            reset: store.bind(Actions.GameConnector.ActiveGame.Reset(), id: "reset"),
                            onBack: store.bind(Actions.GameConnector.ActiveGame.Back(), id: "back")
                        )
                    )
                }
            }()
        )
    }
}

fileprivate extension GameState.WinningPath {
    func toViewCrossLine() -> GameView.Board.CrossLine {
        GameView.Board.CrossLine(
            start: GameView.Board.CrossLine.Location(row: start.row, column: start.column),
            end: GameView.Board.CrossLine.Location(row: end.row, column: end.column)
        )
    }
}

fileprivate extension Core.GameState.Player {
    var toView: GameView.Player {
        switch self {
        case .player_O:
            return .player_O
        case .player_X:
            return .player_X
        }
    }
}

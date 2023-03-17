//
//  ContentView.swift
//  TicTacToe
//
//  Created by Andrii Halushka on 13.05.2021.
//

import SwiftUI
import Core

extension GameView {
    enum GameState: Equatable {
        case idle(onStart: Command)
        case active(ActiveGame)
    }
    
    struct ActiveGame: Equatable {
        let board: Board
        let turnOwner: Player
        let onBack: Command
    }
    
    public enum Player: Equatable {
        case player_X
        case player_O
        
        static var initial: Player {
            .player_X
        }
    }
    
    struct Board: Equatable {
        var row1: Row
        var row2: Row
        var row3: Row
        
        var crossLine: CrossLine?
        
        struct CrossLine: Equatable {
            let path: [Location]
            
            struct Location: Equatable {
                let row: Int
                let column: Int
            }
        }
        
        struct Row: Equatable {
            let first: SquareState
            let second: SquareState
            let third: SquareState
        }
        
        enum SquareState: Equatable {
            case empty(onTap: Command)
            case filled_x
            case filled_0
        }
    }
}

struct GameView: View {
    let state: GameState
    
    var body: some View {
        switch state {
        case .idle(let onStart):
            IdleGameView(
                onStart: onStart.perform
            )
        case .active(let game):
            ActiveGameView(
                board: game.board,
                onBack: game.onBack.perform
            )
        }
    }
}

extension GameView {
    struct IdleGameView: View {
        let onStart: () -> Void
        
        var body: some View {
            Button(action: onStart) {
                Text("Start")
                    .foregroundColor(Color.black)
                    .padding()
                    .background {
                        Capsule()
                            .padding(.horizontal, -30)
                            .foregroundColor(Color.yellow)
                    }
            }
        }
    }
}

extension GameView {
    struct ActiveGameView: View {
        let board: Board
        var onBack: () -> Void
        
        var body: some View {
            VStack {
                BoardView(board: board)
                
                Button(action: self.onBack) {
                    Text("Back")
                }
            }
        }
        
        struct BoardView: View {
            let board: Board
            
            var body: some View {
                VStack(alignment: .center, spacing: 1) {
                    HStack(alignment: .center, spacing: 1) {
                        square(for: board.row1.first)
                        square(for: board.row1.second)
                        square(for: board.row1.third)
                    }
                    
                    HStack(alignment: .center, spacing: 1) {
                        square(for: board.row2.first)
                        square(for: board.row2.second)
                        square(for: board.row2.third)
                    }
                    
                    HStack(alignment: .center, spacing: 1) {
                        square(for: board.row3.first)
                        square(for: board.row3.second)
                        square(for: board.row3.third)
                    }
                }
                .overlay(alignment: .center) {
                    if let crossLine = board.crossLine {
                        GeometryReader { geo in
                            Path { path in
                                func middlePointOfSquare(in location: GameView.Board.CrossLine.Location) -> CGPoint {
                                    let totalSquaresInLine: CGFloat = 3
                                    let squareLength: CGFloat = geo.size.width / totalSquaresInLine
                                    let halfStep = squareLength / 2
                                    
                                    let x = CGFloat(location.row - 1) * squareLength + halfStep
                                    let y = CGFloat(location.column - 1) * squareLength + halfStep
                                    
                                    return CGPoint(x: x, y: y)
                                }
                                
                                crossLine.path.first.map {
                                    path.move(to: middlePointOfSquare(in: $0) )
                                }
                                
                                crossLine.path.dropFirst().forEach { location in
                                    path.addLine(to: middlePointOfSquare(in: location))
                                }
                            }
                            .stroke(
                                Color.red.opacity(1),
                                style: StrokeStyle(
                                    lineWidth: 30,
                                    lineCap: .round
                                )
                            )
                        }
                    } else {
                        EmptyView()
                    }
                }
                .padding()
                .aspectRatio(1, contentMode: .fit)
            }
            
            @ViewBuilder
            func square(for state: GameView.Board.SquareState) -> some View {
                switch state {
                case .filled_x:
                    BoardSquere {
                        XMarkShape()
                            .foregroundColor(.orange)
                    }
                case .filled_0:
                    BoardSquere {
                        Circle()
                            .foregroundColor(.black)
                    }
                case .empty(let onTap):
                    BoardSquere(
                        content: {
                            EmptyView()
                        },
                        onTap: onTap
                    )
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(
            state: .active(
                GameView.ActiveGame(
                    board: GameView.Board(
                        row1: GameView.Board.Row(
                            first: .filled_x,
                            second: .empty(onTap: .nop),
                            third: .empty(onTap: .nop)
                        ),
                        row2: GameView.Board.Row(
                            first: .empty(onTap: .nop),
                            second: .filled_x,
                            third: .empty(onTap: .nop)
                        ),
                        row3: GameView.Board.Row(
                            first: .empty(onTap: .nop),
                            second: .empty(onTap: .nop),
                            third: .filled_x
                        ),
                        crossLine: GameView.Board.CrossLine(
                            path: [
                                GameView.Board.CrossLine.Location(row: 1, column: 1),
                                GameView.Board.CrossLine.Location(row: 3, column: 3)
                            ]
                        )
                    ),
                    turnOwner: .player_X,
                    onBack: .nop
                )
            )
        )
    }
}
#endif

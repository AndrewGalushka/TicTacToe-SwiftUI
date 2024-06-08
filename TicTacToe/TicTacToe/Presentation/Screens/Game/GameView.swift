//
//  ContentView.swift
//  TicTacToe
//
//  Created by Andrii Halushka on 13.05.2021.
//

import SwiftUI
import Core

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
                onReset: game.reset.perform,
                onBack: game.onBack.perform
            )
        }
    }
    
    enum GameState {
        case idle(onStart: Command)
        case active(ActiveGame)
    }
    
    struct ActiveGame {
        let board: Board
        let turnOwner: Player
        let reset: Command
        let onBack: Command
    }
    
    public enum Player {
        case player_X
        case player_O
        
        static var initial: Player {
            .player_X
        }
    }
    
    struct Board {
        var row1: Row
        var row2: Row
        var row3: Row
        
        let size = 3
        
        var crossLine: CrossLine?
        
        struct CrossLine {
            let start: Location
            let end: Location
            
            struct Location {
                let row: Int
                let column: Int
            }
        }
        
        struct Row {
            let first: SquareState
            let second: SquareState
            let third: SquareState
        }
        
        enum SquareState {
            case empty(onTap: Command)
            case filled_x
            case filled_0
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
                    .frame(maxWidth: .infinity)
                    .background {
                        Capsule()
                            .foregroundColor(Color.yellow)
                    }
            }
            .padding(32)
        }
    }
}

extension GameView {
    struct ActiveGameView: View {
        let board: Board
        var onReset: () -> Void
        var onBack: () -> Void
        
        var body: some View {
            VStack {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "arrow.backward")
                    }
                    Spacer()
                    Button(action: onReset) {
                        Image(systemName: "pencil.and.outline")
                    }
                }
                BoardView(board: board)
            }
            .padding(30)
        }
    }
    
    struct BoardView: View {
        let board: Board
        @State private var crossAnimation: Bool = false
        
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
                    let winningCrossLineThickness: CGFloat = 16
                    GeometryReader { geo in
                        Path { path in
                            let squareLength: CGFloat = geo.size.width / CGFloat(board.size)
                            
                            func middlePointOfSquare(in location: Board.CrossLine.Location) -> CGPoint {
                                let halfStep = squareLength / 2
                                
                                let x = CGFloat(location.column) * squareLength + halfStep
                                let y = CGFloat(location.row) * squareLength + halfStep
                                
                                return CGPoint(x: x, y: y)
                            }
                            
                            let start = middlePointOfSquare(in: crossLine.start)
                            let finish = middlePointOfSquare(in: crossLine.end)
                            
                            path.move(to: start)
                            path.addLine(to: finish)
                        }
                        .trim(from: 0, to: crossAnimation ? 1 : 0)
                        .stroke(
                            Color.white,
                            style: StrokeStyle(
                                lineWidth: winningCrossLineThickness,
                                lineCap: .round
                            )
                        )
                        .onAppear {
                            withAnimation {
                                crossAnimation = true
                            }
                        }
                        .onDisappear {
                            crossAnimation = false
                        }
                    }
                } else {
                    EmptyView()
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
        
        @ViewBuilder
        func square(for state: GameView.Board.SquareState) -> some View {
            switch state {
            case .filled_x:
                BoardSquare {
                    CrossShape()
                }
                .foregroundStyle(.orange.opacity(0.2))
            case .filled_0:
                BoardSquare {
                    Circle()
                }
                .foregroundColor(.black)
            case .empty(let onTap):
                BoardSquare(
                    content: {
                        Path()
                    },
                    onTap: onTap
                )
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
                            start: GameView.Board.CrossLine.Location(row: 0, column: 0),
                            end: GameView.Board.CrossLine.Location(row: 2, column: 2)
                        )
                    ),
                    turnOwner: .player_X, 
                    reset: .nop,
                    onBack: .nop
                )
            )
        )
    }
}
#endif

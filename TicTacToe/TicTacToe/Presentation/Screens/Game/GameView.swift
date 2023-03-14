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
        
        var crossLineVector: CrossLineVector?
        
        struct CrossLineVector: Equatable {
            let startPoint: UnitPoint
            let endPoint: UnitPoint
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
                .padding()
                .aspectRatio(1, contentMode: .fit)
                .overlay(alignment: .center) {
                    if let crossLine = board.crossLineVector {
                        GeometryReader { geo in
                            Path { path in
                                path.move(to: CGPoint(x: 10, y: geo.size.height / 2))
                                path.addLine(to: CGPoint(x: geo.size.width - 10, y: geo.size.height / 2))
                            }
                            .rotation(
                                .degrees(
                                    <#T##degrees: Double##Double#>
                                )
                            )
                        }
                    } else {
                        EmptyView()
                    }
                }
            }
            
            @ViewBuilder
            func square(for state: Board.SquareState) -> some View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView.init(state: .idle(onStart: .nop))
    }
}

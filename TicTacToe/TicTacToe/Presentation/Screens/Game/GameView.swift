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
            Button(action: onStart.perform) {
                Text("Start")
                    .foregroundColor(Color.black)
                    .padding()
                    .background {
                        Capsule()
                            .padding(.horizontal, -30)
                            .foregroundColor(Color.yellow)
                    }
            }
        case .running(let onBack):
            ActiveGameView(
                onBack: onBack.perform
            )
        }
    }
    
    struct ActiveGameView: View {
        var onBack: () -> Void
        
        var body: some View {
            VStack {
                grid()
                
                Button(action: self.onBack) {
                    Text("Back")
                }
            }
        }
        
        func grid() -> some View {
            VStack(alignment: .center, spacing: 1) {
                ForEach(0..<3) { _ in
                    HStack(alignment: .center, spacing: 1) {
                        ForEach(0..<3) { _ in
                            BoardSquere()
                        }
                    }
                }
            }
            .padding()
            .aspectRatio(1, contentMode: .fit)
        }
    }
    
    struct BoardSquere: View {
        @State
        private var isTicked: Bool = false
        
        var body: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .border(Color.black, width: 1)
                
                if isTicked {
                    Circle()
                        .inset(by: 10)
                        .foregroundColor(Color.orange)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.isTicked.toggle()
            }
        }
    }
}

extension GameView {
    enum GameState: Equatable {
        case idle(onStart: Command)
        case running(onBack: Command)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView.init(state: .idle(onStart: .nop))
    }
}

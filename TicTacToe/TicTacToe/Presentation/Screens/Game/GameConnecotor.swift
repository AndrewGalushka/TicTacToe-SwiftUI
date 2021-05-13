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
        GameView(
            state: {
                switch state.game {
                case .idle:
                    return .idle(onStart: store.bind(Actions.GameConnector.Start(), id: "start"))
                case .running(_):
                    return .running(onBack: store.bind(Actions.GameConnector.BackToMainMenu(), id: "back"))
                case .ended(_):
                    return .idle(onStart: store.bind(Actions.GameConnector.Start(), id: "start"))
                }
            }()
        )
    }
}

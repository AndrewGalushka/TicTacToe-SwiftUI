//
//  RootView.swift
//  TicTacToe
//
//  Created by Andrii Halushka on 13.05.2021.
//

import SwiftUI
import Core

struct RootCoordinatorConnector: StoreConnector {
    func map(state: AppState, store: EnvironmentStore) -> some View {
        RootCoordinator()
    }
}

struct RootCoordinator: View {
    var body: some View {
        GameConnecotor()
    }
}

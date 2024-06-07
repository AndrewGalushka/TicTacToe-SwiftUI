//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Andrii Halushka on 13.05.2021.
//

import SwiftUI
import Core

@main
struct TicTacToeApp: App {
    @StateObject var store = EnvironmentStore(
        store: 
            AppStore(state: .initial, reducer: reduce(_:with:), middlewares: [])
    )
    
    var body: some Scene {
        WindowGroup {
            RootCoordinatorConnector()
                .environmentObject(store)
        }
    }
}

//
//  Connector.swift
//  TicTacToe
//
//  Created by Andrii Halushka on 14.05.2021.
//

import SwiftUI

public protocol StoreConnector: View {
    associatedtype Content: View
    func map(state: AppState, store: EnvironmentStore) -> Content
}

public extension StoreConnector {
    var body: some View {
        Connected<Content>(map: map)
    }
}

fileprivate struct Connected<V: View>: View {
    @EnvironmentObject var store: EnvironmentStore
    
    let map: (_ state: AppState, _ store: EnvironmentStore) -> V
    
    var body: V {
        map(store.state, store)
    }
}
